# Exercises

- [Exercises 1](exercises01.md): Due at 5 PM on Friday, February 14, 2020.  
- [Exercises 2](exercises02.md): Due at 5 PM on Friday, March 13, 2020.    
- Exercises 3: TBA  
- Exercises 4: TBA  

<!-- - 
- 
- [Exercises 3](exercises03.md): Due at beginning of class on Monday, April 8, 2019.  
- [Exercises 4](exercises04.md): Due at 5 PM on Friday, April 26, 2019.  
 -->

# How to prepare and submit your reports

For both HW and projects, you will be evaluated both on the technical correctness (50%) and the overall intellectual quality (50%) of your approach and write-up.  Strive to make each write-up self-contained and something that a future employer would find engaging and impressive.  I've given some more specific guidelines on organization below.  These guidelines are geared more towards the longer writeups for more complex data sets, but even for short problems, their general spirit should be followed.       

Prepare your reports using RMarkdown, so that they are fully reproducible, carefully integrating visual and numerical evidence with prose.  You may work solo or in groups of 4 or fewer people.  If you're working in a group, please turn in a single submission with all of your names attached.  

To submit, please e-mail Rimli at <rimlisengupta@gmail.com> with the subject line "SDS 323 Exercises N: name here" where N is the exercise number as appropriate (1, 2, etc.) And obviously use your own name in the subject, or the names of all your group members if applicable.

Your e-mail should have two links in it, one to a .md file and one to a .Rmd file:  
1) A link to a GitHub file where the final report has been created in Markdown (.md) format.  That means you should knit your RMarkdown file to a .md output.  PDF is acceptable if for whatever reason you can't get things to work with .md output, but definitely not HTML -- it doesn't render properly on GitHub.  _This should integrate all numerical and visual evidence in a single document,_ and it should follow the standards of reproducibility outlined in the slides on [The Data Scientist's Toolbox](https://github.com/jgscott/SDS323/blob/master/slides/00_toolbox/00_datascience_toolbox.pdf) that we went over in class.  
2) A link to the raw .Rmd file that can be used to reproduce your Markdown output from scratch.

Note: all the support files (images, etc) also need to be pushed your GitHub site, otherwise things will not display correctly!  If you can't see images in your .md document in _your_ browser, then I can't see them in mine, either.    

If you need to include mathematical expressions in your report, you can use Markdown's [math syntax](https://github.com/cben/mathdown/wiki/math-in-markdown).  Alternatively, you can just handwrite the math, snap a photo, and include the image in the final report.  This is a simple, low-overhead option.



# What should a data-analysis write-up look like?


### Organization  

When writing your report, organization will set you free.  In general, your write-up needs to convey the following elements:
- an overview of the problem or question you're trying to address.  
- your data and how you went about analyzing it.  
- the results of your analysis (plots, numbers, etc)
- your substantive conclusions.  

Every single data analysis problem has all these elements.  For longer writeups, you could certainly use each of these bullet points as a standalone section with its own title ("Question", "Data", "Methods", "Results", "Conclusions").  That is, in fact, how most scientific papers that report on data analyses are organized. For something like your project or a lengthy homework problem, it's a great starting point for your outline (although don't feel like you have to follow it slavishly if you see a good reason to depart from it).  For shorter writeups, these might not be standalone sections, but the major elements still need to be there.  

It is pretty much impossible to write a complete, high quality report of a data analysis that is missing or unclear about one of these major elements.  Here are few tips in getting the level of detail right.  

- Use good judgment about your audience when introducing the question.  This needn't be long, but it should be clear.  Don't assume too much prior knowledge of a problem.  Obviously if everyone in your audience already knows the question, this can be extremely brief, but at least some introduction to the question for the purpose of context is almost always warranted.)

- Always be clear about what data/variables you used to address the question.  This is where you most likely need to get specific.  For example, suppose you are building a model to predict the price of a house for tax purposes.  Don't say, "I ran a regression" when you instead can say, "I fit a linear regression model to predict price that included a house's size and neighborhood as predictors." (Or list the predictors in a table.) Justify important or nonobvious features of your modeling approach. 

- Usually your Data description will contain plots or tables (although occasionally not).  If you feel that a plot helps the reader understand some crucial aspect of the problem or data set itself---as opposed to your results---then include it.  A great example here is Tables 1 and 2 in the [main paper on the PREDIMED study](http://www.nejm.org/doi/pdf/10.1056/NEJMoa1200303).  These tables help the reader understand some important properties of the data and approach, but not the results of the study itself.  

- In your results section, include any figures and tables necessary to make your case.  Label them (Figure 1, 2, etc), give them informative captions, and refer to them in the text by their numbered labels where you discuss them.   Typical things to include here may include: pictures of the data; pictures and tables that show the fitted model; tables of model coefficients and summaries.  


### General advice

- Make the sections as short or long as they need to be.  For example, a conclusions section is often pretty short, while a results section is usually a bit longer.   

- It's OK to use the first person to avoid awkward or bizarre sentence constructions, but try to do so sparingly.  

- Do not include computer code unless explicitly called for.  Note: model outputs do not count as computer code.  Outputs should be used as evidence in your results section (ideally formatted in a nice way).  By code, I mean the sequence of commands you used to process the data and produce the outputs.  Your code goes in the raw .Rmd file and is there for the purposes of reproducibility.  

- When in doubt, use shorter words and sentences.  

- A very common way for reports to go wrong is when the writer simply narrates the thought process he or she followed: :First I did this, but it didn't work.  Then I did something else, and I found A, B, and C.  I wasn't really sure what to make of B, but C was interesting, so I followed up with D and E.  Then having done this..."  Do not do this.  The desire for specificity is admirable, but the overall effect is one of amateurism.  Follow the recommended outline above.  


### Example

[Here's a good example of a write-up](http://jgscott.github.io/teaching/writeups/files/example_writeup1.pdf) for an analysis of a few relatively simple problems.  Because the problems are so straightforward, there's not much of a need for an outline of the kind described above.  Nonetheless, the spirit of these guidelines is clearly in evidence.   Notice the clear exposition, the labeled figures and tables that are referred to in the text, and the careful integration of visual and numerical evidence into the overall argument.  This is one worth emulating.    

