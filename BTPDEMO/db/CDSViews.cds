namespace cappo.cds;

using {
    anubhav.db.master,
    anubhav.db.transaction
} from './data-model';

context CDSViews {
    define view![POWorkList] as
        select from transaction.purchaseorder {
            key PO_ID                             as![PurchaseOrderId],
            key Items.PO_ITEM_POS                 as![ItemPosition],
                PARTNER_GUID.BP_ID                as![PartnerId],
                PARTNER_GUID.COMPANY_NAME         as![CompanyName],
                GROSS_AMOUNT                      as![GrossAmount],
                NET_AMOUNT                        as![NetAmlount],
                TAX_AMOUNT                        as![TaxAmount],
                CURRENCY                          as![CurrencyCode],
                OVERALL_STATUS                    as![Status],
                Items.PRODUCT_GUID                as![ProductId],
                Items.PRODUCT_GUID.DESCRIPTION    as![ProductName],
                PARTNER_GUID.ADDRESS_GUID.CITY    as![City],
                PARTNER_GUID.ADDRESS_GUID.COUNTRY as![Country]
        };

    define view![ProdcutValueHelp] as
        select from master.product {
            @EnduserText.label: [{
                language: 'EN',
                text    : 'Product Id'
            }, {
                language: 'DE',
                text    : 'Prodekt Id'
            }]
            PRODUCT_ID  as![ProductId],
            @EnduserText.label: [{
                language: 'EN',
                text    : 'Product Description'
            }, {
                language: 'DE',
                text    : 'Prodekt Desc '
            }]
            DESCRIPTION as![Description]
        };

    define view![ItemView] as
        select from transaction.poitems {
            PARENT_KEY.PARTNER_GUID.NODE_KEY as![CustomerId],
            PRODUCT_GUID.NODE_KEY            as![ProductId],
            CURRENCY                         as![CurrencyCode],
            GROSS_AMOUNT                     as![GrossAmount],
            NET_AMOUNT                       as![NetAmount],
            TAX_AMOUNT                       as![TaxAmount],
            PARENT_KEY.OVERALL_STATUS        as![Status]
        };

    define view![ProductView] as
        select from master.product
        // Mixin is a keyword to define lose couplung
        // which woll never lead items data for product rather load on demand
        mixin {
            // view on view
            PO_ORDER : Association[ * ] to ItemView
                           on PO_ORDER.ProductId = $projection.ProductId
        }
        into {
            NODE_KEY                           as![ProductId],
            DESCRIPTION                        as![Description],
            CATEGORY                           as![Category],
            PRICE                              as![Price],
            SUPPLIER_GUID.BP_ID                as![SupplierId],
            SUPPLIER_GUID.COMPANY_NAME         as![CompmanyName],
            SUPPLIER_GUID.ADDRESS_GUID.CITY    as![City],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as![Country],
            // Exposed Association as runtime in odata we will see a link toload dependent data
            PO_ORDER                           as![To_Items]
        };

    define view CProductValuesView as
        select from ProductView {
            ProductId,
            Country,
            sum(
                To_Items.GrossAmount
            ) as![TotalPurchaseAmount] : Decimal(10, 2),
            (
                To_Items.CurrencyCode
            ) as![CurrencyCode]
        }
        group by
            ProductId,
            Country,
            To_Items.CurrencyCode;
}
