#!/bin/bash
# Run full deployment command only if the generated package contains new or changed metadata
echo "---- 🎁 Deploying all metadata with Selected Tests ONLY 🎁 ----"
#sfdx force:source:deploy -p force-app --testlevel RunLocalTests --verbose -w 300 || exit 1
sfdx force:source:deploy -p force-app --testlevel RunSpecifiedTests --runtests B2BCartControllerTest,B2BCategoryDetailsControllerTest,B2BCommerceProxyTest,B2BProductDetailsControllerTest,B2BProductPricingControllerTest,S5_GTM_ComponentControllerTest --verbose -w 300  || exit 1

