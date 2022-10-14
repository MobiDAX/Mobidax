# mobidax
[![Codemagic build status](https://api.codemagic.io/apps/5e4bd56247dcea000e4ae8ac/5e4bd56247dcea000e4ae8ab/status_badge.svg)](https://codemagic.io/apps/5e4bd56247dcea000e4ae8ac/5e4bd56247dcea000e4ae8ab/latest_build)

Mobile Application for Trading Digital Assets

## Development guidelines
### DO's

* Use selectors in state classes to get specific data from state [click here!](https://pub.dev/packages/async_redux/#selectors)
* Use subclassing for actions to make access to state easier and reduce boilerplate [click here!](https://pub.dev/packages/async_redux/#action-subclassing)
* Don't reinvent the wheel, use already made widgets everywhere where possible
* If something is not working out - you're fighting against the framework,
read the documentation again and fight with the framework agains the problem.
* All custom widgets must be flexible as much as possible (any number of child, colors etc.)
* Use ListView, Table, GridView instead of Row, Column

### DONT'S

* Write the same code twice.
* Overcomplicate widgets. Less widget's is less load and better performance
* Limit your widget's functionality (MyWidget({columnThreeTitle: "Oops.."})
* Use colors not defined in ThemeData (Container(Colors.coral))
* Use one column GridView (use ListView instead)