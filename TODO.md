# 📝 TODO List for Contributors

If you're interested in contributing, here are some important tasks and improvements to consider. Any contribution, big or small, is highly appreciated!

## Current Issues and Enhancements Needed
- [x] **Bug Fix**: Shortcuts occasionally stop working.
- [ ] **Testing**: Conduct comprehensive testing to ensure the app functions correctly across different scenarios.
- [x] **AI Button Feature**: Add an AI button to auto-fill keys when clicked (this should appear when selecting any language).
- [ ] **Empty Data Display**: Display a meaningful message or placeholder when there is no data to show.
- [ ] **Settings Page Redesign**: Revamp the design of the settings page for better user experience and aesthetics.
- [x] **Error on Card Generation**: Fix the bug where data does not populate the controllers when it is generated.
- [x] **Default Language Handling**: Ensure that if the default language is missing in an open project, it gets added with the keys of the longest JSON read.
- [x] **AI Service Abstraction**: Refactor the code to remove the direct use of "gemini" and employ an abstract class structure to enable compatibility with other AI services.
- [x] **Prompt Improvement**: Enhance the prompt generation logic for better accuracy and results.
- [x] **Settings Info**: Add in the settings page link how to obtain gemini key.
- [x] **Project Name Change**: Update the app's name to "Treefy".
- [x] **Logo Creation**: Design a logo using an image of a tree for a more fitting visual identity.
- [ ] **Bug Open Folder**: See why when open folder using shortcuts make it stop working
- [x] **Update Prompt**: Add in it give me the best result used in the Application interfaces
- [x] **Update icons**: the open folder ,save,back not good
- [ ] **Update Naming**: the generate on key,card not clear
- [ ] **generate const keys notworks**
- [x] **Add loader**: after each update
- [ ] **save text edit**:in edit page add shortcut for save
- [x] **The search dialog is late**:update its shape and make it faster
- [x] **fix error in small screen**:the dark mode is activated in the sidebar even when it not activated
- [-]**store the last opened path**: re open it when open the app
- [-]**save unsaved files in temp location**: after a while or something
- [-]**show alert after saving**: saved correctly
- [x]**improve the way of getting the result**: find the ```json that end by ``` or find { end by } and get the result
- [x]**fix infinite loading**: when there are an error in fetching
- [x]**ADD checking for translations**: add new file for the keys that have been checked in the langs
- [x]**remove cherry toast**:use toastification without context
- [x]**re improve the code in the Ai Services**:use same way i remove gemini package and use same way in all sub classes and make the code shared
- [x]**see why when generate in lang not works**
- [-]~~**decrypt the api key**:~~
- [ ]**use git in app**: for preventing data lose
- [x]**re focus on the shortcuts**:after edit any thing re request focus
- [x]**fix when search the langs apears**
- [x]**The type bar not working correctly**:dont use index , also thier ar an err in another thing?
- [x]**remove the transparency form dialogs**:the text cant be read clearly
- [x] **fix over filling**: if value have data prevent ai from refill it with new value
- [=] **add switch for auto generate in inline edit**: when press enter it auto generate generate content
- [x] fix bug in key_page when filtered
- [ ] support more langs(gen const keys,map);
- [ ] error in updating key (i think with filtered)


new names for switches
Auto-generate content on key creation: (For "Auto Generate on Key")
Auto-generate language values on language addition: (For "Auto Generate on Lang")
Auto-fill missing content on Edit page: (For "Auto Generate on Card")

Auto generate missing value on Inline edit


## To be tried
- [x] **remove the edit page and make it inline like excel**
- [ ] **try to add the app feature to the localization_lite package**

**Your contributions can make a significant impact. If you're ready to get started or have any questions, feel free to reach out!**



## For Package
 - [x] add ai for localization lite or create new package - me
 - [x] in debuging mode or in gen mode get key that called and get the translation of it in terminal (for non await)
 if with await show the translation 
 add selected lang in the package
 i think i can alter the json file on the fly when we on the app?
 if     




## do tests
 [x] no internet call 
 [ ] lang exists
 [ ] fix the lang exists in generate in lang
 [ ] need time out in online request 30 sec
 [ ] 
 ## test package 
 [x] add lang
 [x] select custom lang
 [x] generate
 [ ]

 ## test site
 new trans
 new user
 new porj
 - multi verify
 - 1 verify
 - free proj
 - paid project
- verify by trans
- view verifications
- edit proj
- export
- disapble
- purchase points
- sell point (no account) with accoutn

- request lang
- reject

- accept request


[ ] record video for each part

[ ] build the powerpoint
[ ] build the report 25%
[ ] power for stage
[ ] rep for sate 30% 





## done tests
 package
  [x] gather keys (gather for the base lang only why)
  [x] high error in the package cant get the supported langs and i dont know what to do keep it right now
  [x] init 
  [x] add lang
  [x] gemini no internet
  [ ] can added modes save after each word or add code to save i think with code is better
  [x] gemini with internet not working as needed

  [ ] clean the code of the package before presentation
 re test 
    [ ] gemini

## desktop app
    [x] fix lang exists 
    [x] fix key exists
    [x] no internet 






## Report
 - [ ] learn uml basics - ali
 - [ ] p1: give description and the value this app will add to the dev - hisham
 - [ ] confirm or improve the p1 - ali
 - [ ] p2:draw usecase and write it,  - ali
 - [ ] p3:draw classes diagram - ali
 - [ ] p4:draw seqance diagram - ali
 - [ ] conrim or improve the p2->p4 - hisham
 - [ ] write the fn requirements
 - [ ] app pages  
 - [ ] testing
 - [ ] Difficulties
 - [ ] Conclusion


## POWERPOINT