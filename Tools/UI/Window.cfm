<!---- after the script ProsisUI.windowCreate I am not sure if this tag should be
indeed needed 
8/5/2013
by Armin
---->


<cfparam name="attributes.name" 	default = "window"> 
<cfparam name="attributes.width" 	default = "300"> 
<cfparam name="attributes.height" 	default = "300"> 
<cfparam name="attributes.actions" 	default = "'Refresh','Pin','Minimize','Maximize','Close'">
<cfparam name="attributes.initShow" default = "false">
<cfparam name="attributes.title"	default = "">
<cfparam name="attributes.source"	default = "">


<cfoutput>
<cfif thisTag.ExecutionMode is 'start'>
    <div id="#attributes.name#" <cfif attributes.initShow eq "false">style="display:none"</cfif>> 

<cfelse>

	</div>

     <script>
         $(document).ready(function() {
               var window = $("###attributes.name#").kendoWindow({
                   width: "#attributes.width#",
                   height: "#attributes.height#",
                   title: "#attributes.title#",
                   actions: [#attributes.actions#],
                   visible: #attributes.initShow#
				   <cfif attributes.source neq "">
				   	  ,content: "#attributes.source#"
				   </cfif>
				   
               });
			   
			   <cfif attributes.initShow eq "true">
			   		window.data("kendoWindow").open();
			   </cfif>

         });
     </script>	

	
	
	
</cfif>

</cfoutput>