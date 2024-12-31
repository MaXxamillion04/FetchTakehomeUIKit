### Maxx Speller Fetch Takehome

### Steps to Run the App
Build in XCode and run, there are no external pods or modules to set up.

The refresh button to fetch latest recipes is in the top-right.

There are three convenience buttons in the top-left. They change the URL where recipes are being fetched from(you will need to refresh the screen after changing the endpoint, however).
From left to right, they are the successful response, the empty response, and the malformed data response. Use these buttons to see how the app behaves in those cases. Then refresh using the button on the right, or pulling down at the top of the collection to refresh.


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
Recipe Screen VIP(and associated unit tests and mocks), ImagesService(and associated unit tests and mocks), NetworkService(and associated mocks)
I prioritized creating the VIP architecture(a subset of VIPER), which I have found to be a scalable, testable and predictable architecture to build new screens and flows using UIKit. I think the solution for image cacheing and general separation of responsibilities throughout the application to be highly scalable to a large application. In a larger application, abstracting services (image service, network service) away from screens makes API calls accessible in multiple parts of the application and through that separation of responsibilities, it makes testing and debugging more straightforward, and code is more reusable as the application grows. Services can be reused, and even VIPs can be made more modular and reusable, such as generic screens with inputted configurations for text or different arrangements of UI elements.
(please note the convenience buttons and underlying logic kind of break the intended architecture and ownership of responsibilities, think of them more like debug elements that wouldnt be exposed in the release build of a production app)

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
This project took me nearly 8 hours, about one working day's equivalent of time. It wasn't my intention to spend this long on it initially, but I read the prompt and it asked for production quality code, so I approached this as though it were just another screen in a much larger application, because this is more like the code one would expect in a production project that I would actually ship at a company, versus just a simple MVP.


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
The decision to use VIP architecture and separate out all of my services made for a significant tradeoff in terms of time and organization, since I could have gone with simpler organization for such a simple project.
I also would have added unit test coverage to the Presenter in the Recipe VIP.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The weakest part would be the polish on the UI itself. Once I had finished the VIP, network layer, image cacheing, gotten the UI to meet the requirements, and finished the unit tests, I really couldn't commit any extra time to adding bells and whistles to the UI. I made sure it looked alright on an ipad and a small and large iphone and called it good. It's just a happy coincidence that the approach I took also looks alright in landscape, or I would have simply disabled the orientation for the project.

The next weakest part of the project is version control, which I started the project with and entirely forgot about until the very end. The way I have handled version control in my professional setting is nothing like this project, everything in a single commit would encapsulate a single task or bugfix, usually with accompanying unit tests, so it's in the step of defining the task where I scope each of our commits.


### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I think sending a 4-5+ hour coding assignment as the opening step in an interview process is somewhat unethical. You're asking candidates to put forward free labor when your copmpany itself has put 0 skin in the game for them, not even a phone call, nor has anyone at your company even read their resume. There may be other deal-breakers at play(years of experience, location, etc) that might disqualify them at any further steps in the process and they don't know before putting half a day to a day's worth of efforts toward your interview process already. Even while completing this, I don't know if the role I am applying for has already been filled, because my only point of contact is an external recruiter who may not even know themselves.
I don't have an issue with issuing coding assignments in general, since they are the best way of seeing real code applicable to mobile app development(and thus are better than, say, leetcode questions). However, you should consider moving this assignment to a later step in the process, to respect the time and effort of all of your potential candidates.
