# Trivia Quiz app


Trivia is an app that :
- allows users to quiz themselves on any of the availabe categories at a chosen level of difficulty
- It tests users in sets of 10 questions
- provides feedback after each question
- sums up the total score for the round and provides an option to restart the game with new setup - new category and difficulty level

Time spent: 7 hours spent in total

The following functionality is available in this app:

- [x] User can view and answer at least 5 trivia questions.
- [x] App retrieves question data from the Open Trivia Database API.
- [x] Fetch a different set of questions if the user indicates they would like to reset the game.
- [x] Users can see score after submitting all questions.
- [x] True or False questions only have two options.  
- [x] Allow the user to choose a specific category of questions.
- [x] Provide the user feedback on whether each question was correct before navigating to the next.
- [x] Has a launchscreen
- [x] Has an app icon

## Video Walkthrough

https://www.loom.com/share/683a00c55f2041f9b35ca007b3dffabf?sid=7d053a16-ed3a-4ee8-8f5f-02a83ef9ea92


## Notes

Challenges 
- Setting up the setup screen to change difficulty levels and category of quiz questions was a challenge. I eventually figured that the set up screens needs to be embedded in the navigation control for everything to work seamlessly.
- Before the embedding, the program never entered the game and froze after hitting the start button
- I still struffle with connecting outlets and actions with the UI elements. Sometimes, I need to re-code the outlets and actions by creating newwer versions of them.

Future improvements :
- Make the question feedback appear at the bottom of the screen instead of a window
- Automatically transition to the next question within 5 seconds of displaying the feedback after the user answers a question
- Provide instructions before the game begins
- At the end of the game, display the score and rank of the user for a chosen category and difficulty level
- Store the user's highest score for each category and difficulty level ; update the Database after each game
- play background music for each category selected
- Design different theme for each difficulty level 

## License

    Copyright [2025] [Sneha Siri Nagabathula]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
