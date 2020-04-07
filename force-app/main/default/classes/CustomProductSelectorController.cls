global with sharing class CustomProductSelectorController {
  global zqu.SelectProductComponentOptions theOptions { get; set; }
    ApexPages.StandardController sc;
  global CustomProductSelectorController(ApexPages.StandardController sc){
      this.sc = sc;
    theOptions = new zqu.SelectProductComponentOptions();
    theOptions.title = 'Sample Code';
    theOptions.subTitle = 'Choose Product and Charges';
    theOptions.mode = zqu.SelectProductComponentOptions.MODE_EDIT;
    // Read-only mode, used to display all the selected product rate plan charges
    //theOptions.mode = zqu.SelectProductComponentOptions.MODE_DETAIL;
    theOptions.quoteType = 'Subscription';
    theOptions.quoteId = 'a1w0E000000XcslQAC';

    // Set the page url for buttons if necessary
    theOptions.previousUrl = '';
    theOptions.saveUrl = '';
    theOptions.cancelUrl = '';
    //theOptions.filterPlugin = new CustomProductFilter();
  }
}