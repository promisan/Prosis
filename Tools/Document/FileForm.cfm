<cf_param name="url.id" default="" type="String">
<cf_param name="url.id1" default="" type="String">
<cf_param name="url.box" default="" type="String">
<cf_param name="url.dir" default="" type="String">
<cf_param name="url.documentserver" default="" type="String">
<cf_param name="url.host" default="" type="String">
<cf_param name="url.pdfscript" default="" type="String">
<cf_param name="url.reload" default="" type="String">
<cf_param name="url.mode" default="" type="String">

<!--- holder of the form --->

<cf_divscroll zindex  = "9100" 
          modal       = "no" 
		  float       = "yes" 
		  width       = "530px" 
		  height      = "380px" 
		  id          = "#url.box#_holdercontent" 
		  close       = "yes"				    
		  overflowy   = "hidden">	
					  
<cf_tableround mode="modal" line="0" totalwidth="516px" totalheight="390px">		
	<cfinclude template="FileFormDialog.cfm">								
</cf_tableround>

</cf_divscroll>	