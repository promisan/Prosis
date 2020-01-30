
<cfparam name="url.taxcode"      default="00">
<cfparam name="url.taxexemption" default="0">

<cf_getQuotation 
    element      = "#url.element#"
	quantity     = "#url.quantity#"
	price        = "#url.price#"
	taxcode      = "#url.taxcode#"
	taxexemption = "#url.taxexemption#">
	
<cfif isValid("numeric",amount)>	
	
<cfoutput>#numberformat(amount,',.__')#</cfoutput>

<cfelse>

0.00

</cfif>