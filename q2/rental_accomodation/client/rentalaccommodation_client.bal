import ballerina/io;

RentalAccommodationClient ep = check new ("http://localhost:9090");

public function main() returns error? {

    
    // 1. CREATE USERS - CLIENT-SIDE STREAMING
   

    io:println("\n CREATE USERS");

    User host = {
        user_id: "HOST-001",
        name: "John Host",
        email: "johnhost@example.com",
        role: "HOST"
    }; 

    User guest = {
        user_id: "GUEST-001",
        name: "Mary Guest",
        email: "maryguest@example.com",
        role: "GUEST"
    };

    Create_usersStreamingClient createUsersClient =
        check ep->create_users();

    check createUsersClient->sendUser(host);
    check createUsersClient->sendUser(guest);

    check createUsersClient->complete();

    CreateUsersResponse? createUsersResponse =
        check createUsersClient->receiveCreateUsersResponse();

    io:println(createUsersResponse);


    
    // 2. ADD PROPERTY
   

    io:println("\n ADD PROPERTY");

    AddPropertyRequest addPropertyRequest = {
        host_id: "HOST-001",
        property_name: "Ocean View Apartment",
        location: "Swakopmund",
        region: "Erongo",
        property_type: "APARTMENT",
        price_per_night: 1200.0,
        status: "AVAILABLE"
    };

    AddPropertyResponse addPropertyResponse =
        check ep->add_property(addPropertyRequest);

    io:println(addPropertyResponse);

    string propertyId = addPropertyResponse.property_id;


   
    // 3. SEARCH PROPERTY
   

    io:println("\n SEARCH PROPERTY ");

    SearchPropertyRequest searchRequest = {
        property_id: propertyId
    };

    SearchPropertyResponse searchResponse =
        check ep->search_property(searchRequest);

    io:println(searchResponse);


   
    // 4. UPDATE PROPERTY
   

    io:println("\n UPDATE PROPERTY ");

    UpdatePropertyRequest updateRequest = {
        property_id: propertyId,
        property_name: "Ocean View Luxury Apartment",
        location: "Swakopmund",
        region: "Erongo",
        property_type: "APARTMENT",
        price_per_night: 1350.0,
        status: "AVAILABLE"
    };

    PropertyResponse updateResponse =
        check ep->update_property(updateRequest);

    io:println(updateResponse);


   
    // 5. LIST AVAILABLE PROPERTIES - SERVER STREAMING
   

    io:println("\n AVAILABLE PROPERTIES ");

    ListPropertiesRequest listRequest = {
        location: "Swakopmund",
        min_price: 500.0,
        max_price: 2000.0
    };

    stream<Property, error?> propertyStream =
        check ep->list_available_properties(listRequest);

    check propertyStream.forEach(function(Property property) {
        io:println(property);
    });


   
    // 6. BOOK PROPERTY
    

    io:println("\n BOOK PROPERTY ");

    BookPropertyRequest bookingRequest = {
        guest_id: "GUEST-001",
        property_id: propertyId,
        check_in_date: "2026-10-10",
        check_out_date: "2026-10-14"
    };

    BookingCartResponse bookingResponse =
        check ep->book_property(bookingRequest);

    io:println(bookingResponse);


    
    // 7. CONFIRM BOOKING
   

    io:println("\n CONFIRM BOOKING ");

    ConfirmBookingRequest confirmationRequest = {
        guest_id: "GUEST-001"
    };

    BookingConfirmation confirmationResponse =
        check ep->confirm_booking(confirmationRequest);

    io:println(confirmationResponse);


   
    // 8. REMOVE PROPERTY
   

    io:println("\n REMOVE PROPERTY ");

    RemovePropertyRequest removeRequest = {
        property_id: propertyId,
        host_id: "HOST-001"
    };

    PropertyListResponse removeResponse =
        check ep->remove_property(removeRequest);

    io:println(removeResponse);
}
