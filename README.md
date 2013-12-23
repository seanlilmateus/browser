##Rubymotion Class Browser
before we keep on __this project is a proof of concept__, the idea is based on the Smalltalk [System Browser aka. Class Browser][2], the corrent POC still missing some features that I'd like to implement.

###If this is just a POC, why don't you make __the real thing__?
well, this project is the result of 4 hours Brainstorming and Coding....
maybe I have a secret REPO where I implement the real thing 😜.

##Usage:
You'll need [Rubymotion][1] to build the this Project.

##Next Step:
- I'd like to separate between this:
    - Classes
	- Modules
	- Protocols

- I'd like to embed the Rubymotion REPL (is it possible?).
- I'd like to be able to support classes that inherints from [NSProxy][3]
- I'd like to have Syntax hightlight in the TextView [coming soon...]
- Solve conflict between **Object-C Object** and **Ruby Object**
- Lazy load of other frameworks? something like MacRuby __framework__, unfortunatelly [Rubymotion][1] doesn't support it in static compilation 🐼.

![image](https://github.com/seanlilmateus/browser/blob/master/screen_shot.PNG?raw=true "Screen Shot")

[1]: http://www.rubymotion.com
[2]: http://wiki.scratch.mit.edu/wiki/Smalltalk#The_System_Browser
[3]: https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSProxy_Class/Reference/Reference.html