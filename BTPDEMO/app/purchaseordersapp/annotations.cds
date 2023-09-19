using CatalogService as service from '../../srv/CatalogService';

annotate CatalogService.POs with @(
UI: {
    SelectionFields  : [
        PO_ID,
        GROSS_AMOUNT,
        LIFECYCLE_STATUS,
        CURRENCY_code,
        PARTNER_GUID.COMPANY_NAME
    ],
    LineItem  : [
        {
             $Type : 'UI.DataField',
           Value : CURRENCY_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'GROSS_AMOUNT',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
    ],
}
 ) ;

