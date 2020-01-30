
<cfparam name="URL.mission" default="UN">

<cfoutput>

<cf_tl id="Function Documenter" var="1">

<cf_screenTop height="100%" title="#lt_text#" jQuery="Yes" html="No" menuaccess="Yes" systemfunctionid="#url.idmenu#">

<cfinclude template="FunctionScript.cfm">
<cf_layoutscript>	 
	 
<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
						   
  	<cf_layoutarea 
         position  = "top"
         name      = "controltop"
         minsize   = "60"
         maxsize   = "60"  
	     size      = "60" splitter="true" overflow="hidden">	
	  			  
		<cf_ViewTopMenu label="#lt_text#">	  
	  		  			  
	</cf_layoutarea>		 
	  
        <cf_layoutarea 
	          position="left"
	          name="controltree"
	          source="FunctionViewTree.cfm?ID2=#url.mission#"			          	          
			  size="240"
			  minsize="240"
			  maxsize="240"
	          overflow="auto"
	          collapsible="true"
	          splitter="true"/>
		
	   <cf_layoutarea  
		    position="center" 
			name="controllist"/>
	
		 <cf_layoutarea
	          position="bottom"
	          name="controldetail" 
			  title="UseCase"        
	          size="400"			  
	          source="FunctionDetail.cfm?id2=#url.mission#"
	          overflow="auto"
	          collapsible="true"
	          initcollapsed="true"
	          inithide="false"
	          splitter="true"/> 
				  			
</cf_layout>
			
</cfoutput>
