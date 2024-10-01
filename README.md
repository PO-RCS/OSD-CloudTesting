OSD-Builder
https://osdbuilder.osdeploy.com/
https://github.com/OSDeploy/OSDBuilder

This is related to OSD Cloud and modifying Wim files to customize them. Looking into this to see if it's possible to inject NetFx3 (.Net 3.5) into a WinRE wim, this is currently a blocker for Wifi support during OSD Cloud.


OSD-Cloud 
https://www.osdcloud.com/
https://github.com/OSDeploy/OSD/tree/master

I've currently got around 60% of our general onboarding steps set up in PPKG form to reduce the amount of time when onboarding a laptop. This is to slim everything down for now to match the current deployment times we experiencince when re-imaging a device and RCS. Generally the process takes around 1.7 hours to complete and this is excluding any additional time/breaks during the process. The aim for OSD Cloud is to work along side our current deployment but for remote availability as well. 

Some things we need to consider is that is it possible to move a fresh device into OSD-Azure/Cloud, without the need to have a installation media. OSD Azure is set up in a way that it requies storage blob with a Wim image (These are specialized images and cannont be default workflow OSD ISO). Something we need to consider as well, is that this is something a technical handy individual needs to perform, as it would involve manual interaction with the device during the OOBE expereience 
