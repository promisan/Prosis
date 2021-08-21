<cfcomponent>

<cfproperty name="FolderTree" type="string" displayname="Folder Tree">
  
<cffunction name="getNodes" access="remote" returntype="array">

   <cfargument name="path"       type="String" required="false" default=""/>
   <cfargument name="value"      type="String" required="true" default=""/>
   <cfargument name="directory"  type="String" required="true" default=""/>
    
   <!--- set up return array --->
      
      <cfset var result= arrayNew(1)/>
      <cfset var s =""/>	  			  
	  
	  <cfif value eq "">
	  	  	   		
		    <cfset s = structNew()/>
            <cfset s.value     = "tree">
			<cfset s.img       = ""> 
			<cfset s.parent    = "tree"> 
									
			<!--- static tree --->
			<cfset s.display   = "#directory#">	
			<cfset s.expand    = "true">					
						
            <cfset arrayAppend(result,s)/>
			
	  <cfelse>			  
	  	 	  
	  	<cfset l = len(value)>
        <cfset val = mid(value,5,l-4)>
		
		<cfif value eq "tree">
			 <cfset value = "">
		</cfif>
		
		<cfdirectory
		   action="LIST" 
		   directory="#directory#\#value#" 
		   name="list" 
		   type="dir" 
		   listinfo="name">
						   			           
	       <cfoutput query="list">
		   
				   	<cfdirectory
					   action    = "LIST" 
					   directory = "#directory#\#value#\#name#" 
					   name      = "check" 
					   type      = "dir" 
					   listinfo  = "name">
													 			           
	            <cfset s = structNew()/>
	            <cfset s.value     = "#value#\#name#">						
				<cfset s.img       = "#SESSION.root#/images/folder_close.gif">
				<cfset s.imgopen   = "#SESSION.root#/images/folder_open.gif">			
				<cfset s.parent    = "#value#"> 
				
				<cfif check.recordcount eq "0"> 
					<cfset s.leafnode=true/>
				</cfif>
				
				<cfset s.display   = "#Name#">			
				<cfset s.href      = "FolderList.cfm?dir=#directory#">
				<cfset s.target    = "right">	
				<cfset s.title     = "aaaaa">
				<cfset s.expand    = "false">					
	            <cfset arrayAppend(result,s)/>	
						
	       </cfoutput>
	   	   	   
	   </cfif>
		      
   <cfreturn result/>
   
</cffunction>

<cffunction name="getNodesV2" access="remote"  returnType="void">

	 <cfargument name="path"       type="String" required="false" default=""/>
     <cfargument name="value"      type="String" required="true" default=""/>
     <cfargument name="directory"  type="String" required="true" default=""/>
    
    <!--- set up return array --->

      <cfset var result= arrayNew(1)/>
      <cfset var s =""/>	  			  
	  
	  <cfif value eq "">
	  	  	   		
		    <cfset s = structNew()/>
            <cfset s.value     = "tree">
			<cfset s.img       = ""> 
			<cfset s.parent    = "tree"> 
									
			<!--- static tree --->
			<cfset s.display   = "#directory#">	
			<cfset s.expand    = "true">					
						
            <cfset arrayAppend(result,s)/>


	  <cfelse>			  
	  	 	  
	  	<cfset l = len(value)>
        <cfset val = mid(value,5,l-4)>
		
		<cfif value eq "tree">
			 <cfset value = "">
		</cfif>
		
		<cfdirectory
		   action="LIST" 
		   directory="#directory#\#value#" 
		   name="list" 
		   type="dir" 
		   listinfo="name">

	       <cfoutput query="list">
		   
				   	<cfdirectory
					   action    = "LIST" 
					   directory = "#directory#\#value#\#name#" 
					   name      = "check" 
					   type      = "dir" 
					   listinfo  = "name">
													 			           
	            <cfset s = structNew()/>
	            <cfset s.value     = "#value#\#name#">						
				<cfset s.img       = "#SESSION.root#/images/folder.png">
				<cfset s.imgopen   = "#SESSION.root#/images/folder_open.gif">			
				<cfset s.parent    = "#value#"> 
				
				<cfif check.recordcount eq "0"> 
					<cfset s.leafnode=true/>
				</cfif>
				
				<cfset s.display   = "#Name#">			
				<cfset s.href      = "FolderList.cfm?dir=#directory#&key=#value#\#name#">
				<cfset s.target    = "right">	
				<cfset s.title     = "aaaaa">
				<cfset s.expand    = "false">					
	            <cfset arrayAppend(result,s)/>	
						
	       </cfoutput>
	   	   	   
	   </cfif>


	   <cfscript>
			threadName = "ws_msg_" & createUUID();
			treenodes = result;

			msg = SerializeJSON(treenodes);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis","tree node ");
			}
				writeOutput(msg);
		</cfscript>
		      

</cffunction>

<cffunction name="hasModifiedFilesSince" access="remote">

	<cfargument name="directory" type="string">
	<cfargument name="since" type="date">
	
	<cfset var rootDirectory = "">
	<cfset var returnValue = 0>
	
	<cfdirectory    action = "list"   
	directory = "#directory#"   
	name = "rootDirectory"
	sort = "name asc">
	
	<cfloop query="rootDirectory">
			<cfif rootDirectory.type eq "Dir">
				<cfif FindNoCase("_thumbnails",name) eq 0>
					<cfset returnValue = hasModifiedFilesSince("#directory#\#name#\",since) >	
					<Cfif returnValue eq 1>
						<cfreturn 1>
					</CFIF>
				</cfif>
			<cfelse>

				<cfif DateCompare(dateLastModified,DateFormat(since,"dd/mm/yyyy")) eq '1'>
					<cfreturn 1>
				</cfif>
			</cfif>
	</cfloop>
	
	<cfreturn returnValue >
	
</cffunction>


<cffunction name="getRecursiveNodes" access="remote" returntype="array" output="yes">

   <cfargument name="path"       type="String" required="false" default=""/>
   <cfargument name="value"      type="String" required="true" default=""/>
   <cfargument name="directory"  type="String" required="true" default=""/>
   <cfargument name="since"   	 type="Date"   required="false"  default=""/>
    
   <!--- set up return array --->
      
      <cfset var result= arrayNew(1)/>
      <cfset var s =""/>	  			  
	  
	  <cfif value eq "">
	  	  	   		
		    <cfset s = structNew()/>
            <cfset s.value     = "#directory#">
			<cfset s.img       = ""> 
			<cfset s.parent    = ""> 
									
			<!--- static tree --->
			<cfset s.display   = "<b>#Directory#</b>">	
			<cfset s.expand    = "true">					
						
            <cfset arrayAppend(result,s)/>
			
	  <cfelse>		
	  
	  	 	  
	  	<cfset l = len(value)>
        <cfset val = mid(value,5,l-4)>
		
		<cfif value eq directory>
			 <cfset LookFor = "#directory#">
		<cfelse>
			 <cfset LookFor = "#path#">
		</cfif>


		<cfdirectory
		   action="LIST" 
		   directory="#LookFor#" 
		   name="list" 
		   listinfo="name,type">
						   			           
	       <cfoutput query="list">

				<cfif list.type eq "Dir" >		
					<cfif FindNoCase("_thumbnails",name) eq 0 and FindNoCase("RECYCLER",name) eq 0>
					   	<cfdirectory
						   action    = "LIST" 
						   directory = "#LookFor#\#name#" 
						   name      = "check" 
						   listinfo  = "name">

							<!--- checks if the directory contains at least one file that has been modified since the given date --->
							<cfset var dirCheck = hasModifiedFilesSince("#LookFor#\#name#\",since)> 
							
							<cfsilent>
							<cf_logpoint mode="append">
								"#LookFor#\#name#\, #dirCheck#
							</cf_logpoint>
							</cfsilent>
							
							<cfif  dirCheck eq '1' > 
					            <cfset s = structNew()/>
					            <cfset s.value     = "#LookFor#\#name#">						
								<cfset s.img       = "#SESSION.root#/images/folder_close.gif">
								<cfset s.imgopen   = "#SESSION.root#/images/folder_open.gif">			
								<cfset s.parent    = "#LookFor#"> 
								
								<cfif check.recordcount eq "0"> 
									<cfset s.leafnode=true/>
								</cfif>
								
								<cfset s.display   = "#Name#">			
								<cfset s.title     = "aaaaa">
								<cfset s.expand    = "false">					
					            <cfset arrayAppend(result,s)/>	
							</cfif>
					</cfif>	
				<cfelse>
					 	<cfif DateCompare(dateLastModified,DateFormat(since,"dd/mm/yyyy")) eq '1'>
				            <cfset s = structNew()/>
				            <cfset s.value     = "#LookFor#\#name#">						
							<cfset s.parent    = "#LookFor#"> 
							<cfset s.leafnode  = true/>
							<cfset s.display   = "#Name#">			
							<cfset s.href      = "Thumbnails.cfm?dir=#LookFor#&name=#name#">
							<cfset s.target    = "right">	
							<cfset s.title     = "aaaaa">
							<cfset s.expand    = "false">					
				            <cfset arrayAppend(result,s)/>		
						</cfif>
				</cfif>		
	       </cfoutput>

	   </cfif>
		      
   <cfreturn result/>
</cffunction>

</cfcomponent>
