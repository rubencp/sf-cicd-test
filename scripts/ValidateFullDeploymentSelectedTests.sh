#!/bin/bash
# Run full deployment command only if the generated package contains new or changed metadata
echo "---- 🎁 Validate new/changed metadata - Run ONLY some Tests 🎁 ----"
sfdx force:source:deploy -p force-app --checkonly --testlevel RunSpecifiedTests --runtests B2BCartControllerTest,B2BCategoryDetailsControllerTest,B2BCommerceProxyTest,B2BProductDetailsControllerTest,B2BProductPricingControllerTest,S5_GTM_ComponentControllerTest --verbose -w 300 || exit 1

