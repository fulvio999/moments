/*
   Utlity to adapt layouts, scrolling depending on page,screen size
*/

/* Depending on the Pagewidht of the Page (ie: the Device type) decide the Height of the scrollable */
function getContentHeight(pageHeight){

    if(root.width > units.gu(80))
        return pageHeight + pageHeight/2 + units.gu(20)
    else
        return pageHeight + pageHeight/2 + units.gu(10) //phone
}
