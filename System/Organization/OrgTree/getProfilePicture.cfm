
<cfparam name="attributes.UserAccount" default="">
<cfparam name="attributes.IndexNo"     default="">
<cfparam name="attributes.gender"      default="M">
<cfparam name="attributes.style"       default="width:80px;height:80px">
<cfparam name="attributes.class"       default="">
<cfparam name="attributes.printmode"   default="0">

<cfset vPhoto = attributes.UserAccount>

<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#attributes.UserAccount#.jpg") OR trim(attributes.UserAccount) eq "">

	<cfset vPhoto = attributes.IndexNo>
		
	<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#attributes.IndexNo#.jpg") OR trim(attributes.IndexNo) eq "">
	
		<cfif attributes.Gender eq "f">
			<cfset vPhoto = "Female">
		<cfelse>
			<cfset vPhoto = "Male">
		</cfif>
				
	</cfif>

</cfif>

<!--- output --->

<cfoutput>
	
	<cfif vPhoto eq "Female">
	
		<cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
	
		<cfif attributes.printmode eq 0>
			<div class="img-circle clsRoundedPicture #attributes.class#" style="background-image:url('#vPhoto#'); #attributes.style#"></div>
		<cfelse>			
			<div style="float:left; padding:20px; width:90px"><img src="#vPhoto#" height="80px" width="80px"></div>	
		</cfif>	
	
	<cfelseif vPhoto eq "Male">
	
		<cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
	
		<cfif attributes.printmode eq 0>
			<div class="img-circle clsRoundedPicture #attributes.class#" style="background-image:url('#vPhoto#'); #attributes.style#"></div>
		<cfelse>
			<div style="float:left; padding:20px; width:90px"><img src="#vPhoto#" height="#height#px" width="#width#px"></div>
		</cfif>	
			
	<cfelse>	
		
		<!---																									
		<cffile action="COPY" 
			source="#SESSION.rootDocumentpath#\EmployeePhoto\#vPhoto#.jpg" 
  		    	destination="#SESSION.rootPath#\CFRStage\EmployeePhoto\#vPhoto#.jpg" nameconflict="OVERWRITE">
											
		<cfset vPhoto = "#SESSION.root#\CFRStage\EmployeePhoto\#vPhoto#.jpg">	
		
		--->		
		
		<cfset vPhoto = "#SESSION.rootDocumentpath#\EmployeePhoto\#vPhoto#.jpg">	
		
				
		<cfset vPhoto = "getFile.cfm?id=00628942.jpg&mode=EmployeePhoto">		
							
		<cfif attributes.printmode eq 0>
			<div><img src="#vPhoto#" style="#attributes.style#" class="img-circle clsRoundedPicture #attributes.class#"></div>
		<cfelse>
			<div style="float:left; padding:20px; width:90px"><img src="#vPhoto#" style="#attributes.style#"  class="#attributes.class#"></div>
		</cfif>			
	
		<!--- too slow : Hanno 4/2/2021
	
		<cfset myImage=ImageNew("#SESSION.rootDocumentpath#\EmployeePhoto/#vPhoto#.jpg")>						
		<cfimage class="img-circle clsRoundedPicture #attributes.class#" style="#attributes.style#" source="#myImage#" action="writeToBrowser">														
		
		--->
	
	
	</cfif>

</cfoutput>

