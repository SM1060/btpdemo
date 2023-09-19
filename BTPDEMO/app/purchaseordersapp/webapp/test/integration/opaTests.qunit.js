sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/cappo/purchaseordersapp/test/integration/FirstJourney',
		'com/cappo/purchaseordersapp/test/integration/pages/POsList',
		'com/cappo/purchaseordersapp/test/integration/pages/POsObjectPage',
		'com/cappo/purchaseordersapp/test/integration/pages/PurchaseOrderItemObjectPage'
    ],
    function(JourneyRunner, opaJourney, POsList, POsObjectPage, PurchaseOrderItemObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/cappo/purchaseordersapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOsList: POsList,
					onThePOsObjectPage: POsObjectPage,
					onThePurchaseOrderItemObjectPage: PurchaseOrderItemObjectPage
                }
            },
            opaJourney.run
        );
    }
);