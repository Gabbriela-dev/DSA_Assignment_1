import ballerina/http;

map<Asset> assetStore = {};
map<Institution> institutionStore = {};

service /assets on new http:Listener(8080) {

    resource function post .(@http:Payload Asset newAsset) returns CreateResponse|http:Conflict {
        assetStore[newAsset.assetTag] = newAsset;
        return {message: "Asset created successfully", asset: newAsset};
    }

    resource function get [string assetTag] () returns Asset|http:NotFound {
        Asset? found = assetStore[assetTag];
        if found is () {
            return http:NOT_FOUND;
        }
        return found;
    }

    resource function get .() returns Asset[] {
        return assetStore.toArray();
    }
}