type AssetStatus "AVAILABLE"|"LOANED_OUT"|"UNDER_MAINTENANCE"|"DISPOSED";

type Asset record {
    string assetTag;
    string name;
    string description;
    string institution;
    string site;
    AssetStatus status;
    string dateAcquired;
    Component[] components;
    Schedule[] schedules;
    WorkOrder[] workOrders;
};

type CreateResponse record {
    string message;
    Asset asset;
};

type ErrorResponse record {
    string message;
};

type Institution record {
    string name;
};

// Placeholders
type Component record {};
type Schedule record {};
type WorkOrder record {};