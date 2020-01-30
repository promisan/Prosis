
<cfmenu name="menu"
    font="verdana"
    fontsize="15"
    type="horizontal"   
    selectedfontcolor="gray">		
					  
	<cfmenuitem 
          display="Record new customer"
          name="Add"
          href="javascript:add()"
          image="#SESSION.root#/Images/customer.gif"/>
		  			 							  
	<cfmenuitem 
          display="Print"
          name="pdf"
          href="javascript:printpdf()"
          image="#SESSION.root#/Images/pdf_small.gif"/>
							
</cfmenu>	

