module.exports = cds.service.impl(async function () {
    const { EmployeeSet, POs } = this.entities;

    // Step 2 define generix handlers
    this.before('UPDATE', EmployeeSet, (req, res) => {
        console.log("Aa Gaya" + req.data.SalaryAmount);
        if (parseFloat(req.data.SalaryAmount) >= 500000) {
            req.error(500, "Salary Must Be less than a millon");
        }
    });

    this.on('boost', async (req, res) => {
        try {
            const ID = req.params[0];
            console.log('Hey, PO with Id' + req.params[0] + "will be boosted")
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=': 20000 },
                NOTE: 'BOOSTED!!'
            }).where(ID);
        } catch (error) {
            return "Error" + error.toString();

        }

    });

    this.on('largestOrder', async (req, res) => {
        try {
            const ID = req.params[0];
            const tx = cds.tx(req);
            // SELECT upto 1 row FROM DBTAB Order By Gross Amount            
            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);
            return reply;
        } catch (error) {

        }
    });
}
);