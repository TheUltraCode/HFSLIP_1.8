# HFSLIP 1.8

**What Is HFSLIP?**

HFSLIP is a Windows batch script meant to slipstream updates into a Windows 2000, XP, or Server 2003 setup ISO (all 32-bit NT5 OSes). It can slipstream normal updates, as well as integrate newer versions of Internet Explorer, Windows Media Player, DirectX, and more.

It was the brain-child of MSFN Forums user TommyP and was developed with the help of user Tomcat76 until early-2010 with the final release `v1.7.10 Beta J`. Work resumed under user Mim0 for a few years under the `v1.7.10 Beta J vX` series until 2013, before being passed onto user Acheron under the `Beta K vX` series up to 2015. Additional contributions were made by user tomasz86, culminating in a fork of Acheron's work called `HFSLIP2000`. Finally, user evgnb came onto the scene in 2020 to pick up Acheron's work to make notable contributions of his own in his `1.7.11X` series, including merging `HFSLIP2000`'s additions.

**First Encounter**

When I first encountered evgnb's latest release, I was severely disappointed at the dismal and non-working state the program was left in; I understand it was a "debug" build, but if you intend on releasing something to the public in my opinion it should very well work. I initially began trying to track-down inividual errors, understanding how exactly HFSLIP was laid-out and where the program would error-out. Before long, however, I began scrutinizing the code, learning more about the batch scripting language, and getting to work on returning the script to a functional state. This involved returning portions of the code closely back to how things were working while retaining any new improvements made to the code in question.

During my quest to fix the code, I began to normalize and refactor the code: the original script has had so many people make contributions to it that things were done differently depending where in the script you looked. While mostly cosmetic, it did serve as a great excuse to more closely examine the entire codebase, making some things more readable or "cleaner" in terms of layout. Better familiarity with the codebase also helped when it came to debugging issues that arose during testing.

With the script cleaned-up and working, I felt I had to do at least one more thing - write documentation. Function trees, function layouts, noting the sub-scripts that exist inside of HFSLIP, and the overall order-of-execution for the entire script - while this kind of documentation will most likely not help the average user, I hope it does help future developers better understand the layout and execution of the code itself. The text files containing such information can be found in the `DOC` directory.

My original work on what I called HFSLIP 1.8 all concluded in late September of 2024, after a month or two of work. And after all was said and done - I wasn't happy with its capabilities! HFSLIP is just too limited and flawed for my Windows 2000 slipstreaming goals. Not only is the update order for getting Windows 2000 up-to-date manually complex, I'm not happy with how DirectX 9 is handled. Maybe if someone with a more comprehensive understanding of the Windows NT5 setup process could come along and...

**Release**

Nearly a year has passed, and now I am deciding to release my code on GitHub instead of keeping it sequestered on MSFN. What gives? It's to advertise my work on a bigger stage with greater visability, for two reasons:
1. Make finding and contributing easier - keeping this work behind private file shares and forum threads isn't ideal in my opinion, not to mention the purpose of GitHub and other git repositories is to facilitate the use of git for version history and control. GitHub would allow potential new contributors to find it more easily, and make tracking changes and forks easier.
2. Acknowledgement - I like being able to more conveniently show individuals what I am capable of. It was not the reason I started working on HFSLIP, of course - I was hoping I wouldn't have to do much.

If you would like to make changes, I only ask to please try to keep things in the style I have it (there are more specific guidelines laid-out in the script itself).

**Setup**

To run HFSLIP, clone this repository and extract it to wherever you like. Then download the necessary "tools" from the sister repository [HFSLIP_TOOLS](https://github.com/TheUltraCode/HFSLIP_TOOLS) and extract those to their respective directories. Run the `hfslip-1.8.cmd` script once to generate all of the missing directories used by HFSLIP. Finally, extract your Windows NT5 setup disc into the "SOURCES" directory. Further how-to-use documentation can be found here ([How-to](https://ballzofiya.be/-/hfslip/howto.html), [Advanced](https://ballzofiya.be/-/hfslip/)).

I would recommend running this script in a VM, disabling UAC, running it from an admin prompt, and piping text output normally sent to the console to an output file defined in HFANSWER.ini (this reduces the run time of the script; I guess outputing text to a terminal has more overhead compared to piping output to a text file).

**Credits**

Thanks to TommyP for coming up with this script to begin with. Thanks to all those who contributed to this project prior. And especially thanks to Tomcat76 for both his support with my endeavor and his hosting of new archive HFSLIP websites.

Shout-out to [ss64.com](https://ss64.com/nt/) and [dostips.com](https://www.dostips.com/) for the useful batch scripting documentation and forum posts.
