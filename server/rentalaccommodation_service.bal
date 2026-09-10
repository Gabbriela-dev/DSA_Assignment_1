import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);


map<Property> properties = {};
map<User> users = {};
map<BookPropertyRequest> bookingCart = {};
map<BookingConfirmation> bookings = {};

int propertyCounter = 1;
int bookingCounter = 1;



@grpc:Descriptor {value: RENTAL_DESC}
service "RentalAccommodation" on ep {


  
    remote function add_property(AddPropertyRequest request)
            returns AddPropertyResponse|error {

        if request.property_name == "" {
            return {
                success: false,
                message: "Property name cannot be empty",
                property_id: ""
            };
        }

        if request.host_id == "" {
            return {
                success: false,
                message: "Host ID cannot be empty",
                property_id: ""
            };
        }

        if request.price_per_night <= 0.0 {
            return {
                success: false,
                message: "Price per night must be greater than zero",
                property_id: ""
            };
        }

        lock {
            string propertyId =
                "PROP-" + propertyCounter.toString();

            Property newProperty = {
                property_id: propertyId,
                host_id: request.host_id,
                property_name: request.property_name,
                location: request.location,
                region: request.region,
                property_type: request.property_type,
                price_per_night: request.price_per_night,
                status: request.status
            };

            properties[propertyId] = newProperty.clone();

            propertyCounter += 1;

            return {
                success: true,
                message: "Property added successfully",
                property_id: propertyId
            };
        }
    }


   
    remote function create_users(
            stream<User, grpc:Error?> clientStream)
            returns CreateUsersResponse|error {

        int usersCreated = 0;

        check clientStream.forEach(function(User user) {

            if user.user_id != "" &&
                user.name != "" &&
                user.email != "" {

                lock {
                    users[user.user_id] = user.clone();
                }

                usersCreated += 1;
            }
        });

        return {
            success: true,
            message: "Users created successfully",
            users_created: usersCreated
        };
    }


  
    remote function update_property(UpdatePropertyRequest request)
            returns PropertyResponse|error {

        lock {

            if !properties.hasKey(request.property_id) {
                return {
                    success: false,
                    message: "Property not found"
                };
            }

            Property existingProperty =
                properties.get(request.property_id);

            if request.price_per_night <= 0.0 {
                return {
                    success: false,
                    message: "Price per night must be greater than zero",
                    property: existingProperty.clone()
                };
            }

            Property updatedProperty = {
                property_id: request.property_id,
                host_id: existingProperty.host_id,
                property_name: request.property_name,
                location: request.location,
                region: request.region,
                property_type: request.property_type,
                price_per_night: request.price_per_night,
                status: request.status
            };

            properties[request.property_id] =
                updatedProperty.clone();

            return {
                success: true,
                message: "Property updated successfully",
                property: updatedProperty
            };
        }
    }


   

    remote function remove_property(RemovePropertyRequest request)
            returns PropertyListResponse|error {

        lock {

            if !properties.hasKey(request.property_id) {
                return {
                    success: false,
                    message: "Property not found",
                    properties: []
                };
            }

            Property propertyToRemove =
                properties.get(request.property_id);

            if propertyToRemove.host_id != request.host_id {
                return {
                    success: false,
                    message:
                        "Host is not authorized to remove this property",
                    properties: []
                };
            }

            string hostRegion = propertyToRemove.region;

            _ = properties.remove(request.property_id);

            Property[] regionalProperties = [];

            foreach Property property in properties {

                if property.region == hostRegion &&
                    property.status == "AVAILABLE" {

                    regionalProperties.push(property.clone());
                }
            }

            return {
                success: true,
                message: "Property removed successfully",
                properties: regionalProperties
            };
        }
    }


    

    remote function list_available_properties(
            ListPropertiesRequest request)
            returns stream<Property, grpc:Error?>|error {

        Property[] availableProperties = [];

        lock {

            foreach Property property in properties {

                boolean locationMatches =
                    request.location == "" ||
                    property.location == request.location;

                boolean minimumPriceMatches =
                    request.min_price <= 0.0 ||
                    property.price_per_night >=
                        request.min_price;

                boolean maximumPriceMatches =
                    request.max_price <= 0.0 ||
                    property.price_per_night <=
                        request.max_price;

                if property.status == "AVAILABLE" &&
                    locationMatches &&
                    minimumPriceMatches &&
                    maximumPriceMatches {

                    availableProperties.push(
                        property.clone()
                    );
                }
            }
        }

        return availableProperties.toStream();
    }


    

    remote function search_property(SearchPropertyRequest request)
            returns SearchPropertyResponse|error {

        lock {

            if !properties.hasKey(request.property_id) {
                return {
                    success: false,
                    status: "NOT_AVAILABLE",
                    message: "Property not found"
                };
            }

            Property property =
                properties.get(request.property_id);

            Property propertyCopy = property.clone();

            if property.status != "AVAILABLE" {
                return {
                    success: false,
                    status: "NOT_AVAILABLE",
                    message:
                        "Property is currently not available",
                    property: propertyCopy
                };
            }

            return {
                success: true,
                status: "AVAILABLE",
                message: "Property found",
                property: propertyCopy
            };
        }
    }


   

    remote function book_property(BookPropertyRequest request)
            returns BookingCartResponse|error {

        if request.guest_id == "" {
            return {
                success: false,
                message: "Guest ID cannot be empty",
                guest_id: "",
                property_id: "",
                check_in_date: "",
                check_out_date: ""
            };
        }

        if request.check_in_date == "" ||
            request.check_out_date == "" {

            return {
                success: false,
                message:
                    "Check-in and check-out dates are required",
                guest_id: request.guest_id,
                property_id: request.property_id,
                check_in_date: request.check_in_date,
                check_out_date: request.check_out_date
            };
        }

        if request.check_out_date <= request.check_in_date {
            return {
                success: false,
                message:
                    "Check-out date must be after check-in date",
                guest_id: request.guest_id,
                property_id: request.property_id,
                check_in_date: request.check_in_date,
                check_out_date: request.check_out_date
            };
        }

        lock {

            if !users.hasKey(request.guest_id) {
                return {
                    success: false,
                    message: "Guest does not exist",
                    guest_id: request.guest_id,
                    property_id: request.property_id,
                    check_in_date: request.check_in_date,
                    check_out_date: request.check_out_date
                };
            }

            User guest = users.get(request.guest_id);

            if guest.role != "GUEST" {
                return {
                    success: false,
                    message: "Only Guests can book properties",
                    guest_id: request.guest_id,
                    property_id: request.property_id,
                    check_in_date: request.check_in_date,
                    check_out_date: request.check_out_date
                };
            }

            if !properties.hasKey(request.property_id) {
                return {
                    success: false,
                    message: "Property not found",
                    guest_id: request.guest_id,
                    property_id: request.property_id,
                    check_in_date: request.check_in_date,
                    check_out_date: request.check_out_date
                };
            }

            Property property =
                properties.get(request.property_id);

            if property.status != "AVAILABLE" {
                return {
                    success: false,
                    message: "Property is not available",
                    guest_id: request.guest_id,
                    property_id: request.property_id,
                    check_in_date: request.check_in_date,
                    check_out_date: request.check_out_date
                };
            }

            bookingCart[request.guest_id] =
                request.clone();

            return {
                success: true,
                message: "Property added to booking cart",
                guest_id: request.guest_id,
                property_id: request.property_id,
                check_in_date: request.check_in_date,
                check_out_date: request.check_out_date
            };
        }
    }


    

    remote function confirm_booking(
            ConfirmBookingRequest request)
            returns BookingConfirmation|error {

        lock {

           

            if !bookingCart.hasKey(request.guest_id) {
                return {
                    success: false,
                    message:
                        "No booking found in cart for this guest",
                    booking_id: "",
                    property_id: "",
                    guest_id: request.guest_id,
                    check_in_date: "",
                    check_out_date: "",
                    number_of_nights: 0,
                    total_cost: 0.0
                };
            }

            BookPropertyRequest pendingBooking =
                bookingCart.get(request.guest_id);


            if !properties.hasKey(
                    pendingBooking.property_id) {

                return {
                    success: false,
                    message: "Property no longer exists",
                    booking_id: "",
                    property_id:
                        pendingBooking.property_id,
                    guest_id: request.guest_id,
                    check_in_date:
                        pendingBooking.check_in_date,
                    check_out_date:
                        pendingBooking.check_out_date,
                    number_of_nights: 0,
                    total_cost: 0.0
                };
            }

            Property property =
                properties.get(
                    pendingBooking.property_id
                );


           

            if property.status != "AVAILABLE" {

                return {
                    success: false,
                    message:
                        "Property is no longer available",
                    booking_id: "",
                    property_id:
                        pendingBooking.property_id,
                    guest_id: request.guest_id,
                    check_in_date:
                        pendingBooking.check_in_date,
                    check_out_date:
                        pendingBooking.check_out_date,
                    number_of_nights: 0,
                    total_cost: 0.0
                };
            }


          

            time:Utc|error checkInResult =
                time:utcFromString(
                    pendingBooking.check_in_date +
                    "T00:00:00Z"
                );

            time:Utc|error checkOutResult =
                time:utcFromString(
                    pendingBooking.check_out_date +
                    "T00:00:00Z"
                );

            if checkInResult is error ||
                checkOutResult is error {

                return {
                    success: false,
                    message:
                        "Invalid date format. Use YYYY-MM-DD",
                    booking_id: "",
                    property_id:
                        pendingBooking.property_id,
                    guest_id: request.guest_id,
                    check_in_date:
                        pendingBooking.check_in_date,
                    check_out_date:
                        pendingBooking.check_out_date,
                    number_of_nights: 0,
                    total_cost: 0.0
                };
            }

            time:Utc checkInUtc = checkInResult;
            time:Utc checkOutUtc = checkOutResult;

            if checkOutUtc <= checkInUtc {

                return {
                    success: false,
                    message:
                        "Check-out date must be after check-in date",
                    booking_id: "",
                    property_id:
                        pendingBooking.property_id,
                    guest_id: request.guest_id,
                    check_in_date:
                        pendingBooking.check_in_date,
                    check_out_date:
                        pendingBooking.check_out_date,
                    number_of_nights: 0,
                    total_cost: 0.0
                };
            }


           

            foreach BookingConfirmation existingBooking
                    in bookings {

                if existingBooking.property_id ==
                        pendingBooking.property_id {

                    boolean overlaps =
                        pendingBooking.check_in_date <
                            existingBooking.check_out_date &&
                        pendingBooking.check_out_date >
                            existingBooking.check_in_date;

                    if overlaps {

                        return {
                            success: false,
                            message:
                                "Property is already booked for the selected dates",
                            booking_id: "",
                            property_id:
                                pendingBooking.property_id,
                            guest_id:
                                request.guest_id,
                            check_in_date:
                                pendingBooking.check_in_date,
                            check_out_date:
                                pendingBooking.check_out_date,
                            number_of_nights: 0,
                            total_cost: 0.0
                        };
                    }
                }
            }


           
            int differenceInSeconds =
                checkOutUtc[0] - checkInUtc[0];

            int numberOfNights =
                differenceInSeconds / 86400;


          

            float totalCost =
                property.price_per_night *
                <float>numberOfNights;


          

            string bookingId =
                "BOOK-" + bookingCounter.toString();


           

            BookingConfirmation confirmation = {
                success: true,
                message:
                    "Booking confirmed successfully",
                booking_id: bookingId,
                property_id:
                    pendingBooking.property_id,
                guest_id: request.guest_id,
                check_in_date:
                    pendingBooking.check_in_date,
                check_out_date:
                    pendingBooking.check_out_date,
                number_of_nights:
                    numberOfNights,
                total_cost:
                    totalCost
            };


            

            bookings[bookingId] =
                confirmation.clone();

            bookingCounter += 1;


          

            _ = bookingCart.remove(
                request.guest_id
            );

            return confirmation;
        }
    }
}
