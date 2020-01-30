<cfparam name="sessionId" 		default="">
<cfparam name="attachmentId" 	default="">

<cfsetting enablecfoutputonly="true">

<cfif structKeyExists(form, "file")>
    <cfset destination = "D:\Prosis\MANTINSA\Document\WorkOrder\#actionId#">
	
	<cfif not DirectoryExists(destination)>
	    <cfdirectory action = "create" directory = "#destination#" >
	</cfif>
    
    <cffile 
		action="upload" 
		filefield="file" 
		destination="#destination#" 
		nameconflict="makeunique">
		
	<cfif cffile.fileWasSaved>
	
		<!--- rename with an underscore prefix --->
		<cffile 
			action="rename" 
			source="#destination#\#cffile.serverFile#"
			destination="#destination#\_#cffile.serverFile#" 
			nameconflict="makeunique">
	
		<cfset UserAcc = "MobileApp">
		<cfset UserFirst = "MobileApp">
		<cfset UserLast = "MobileApp">
		
		<!--- get user from the session --->
		<cfif sessionId neq "">
			<cfquery name="getUser" 
				datasource="AppsSystem">
				
					SELECT TOP 1 	
							U.*
					FROM 	UserNames U
							INNER JOIN UserStatus S
								ON U.Account = S.Account
					WHERE	S.HostSessionId = '#sessionId#'
				
			</cfquery>
			
			<cfif getUser.recordCount eq 1>
				<cfset UserAcc = getUser.Account>
				<cfset UserFirst = getUser.FirstName>
				<cfset UserLast = getUser.LastName>
			</cfif>
			
		</cfif>
			
		<cfquery name="InsertAttachment" 
			datasource="AppsSystem">
			
			INSERT INTO Attachment
				(
					AttachmentId,
					DocumentPathName,
				 	Server, 
				 	ServerPath, 
				 	FileName, 
				 	Reference,
				 	AttachmentMemo,
				 	OfficerUserId, 
				 	OfficerLastName, 
				 	OfficerFirstName
				)
			VALUES
				(
					'#AttachmentId#',
			  		'WorkOrder',		  				 
					'document', 
					'WorkOrder/#actionId#/',
					'_#cffile.serverFile#',
					'#actionId#',
					'#memo#',
					'#UserAcc#',
					'#UserLast#',
					'#UserFirst#'
			 	) 
		</cfquery>
		
		<cfif CGI.HTTPS eq "off">
	      <cfset protocol = "http">
		<cfelse> 
		  <cfset protocol = "https">
		</cfif>
		
		<cfquery name="LogAction" 
			datasource="AppsSystem">
			
			INSERT INTO AttachmentLog
				(
					AttachmentId,
				 	SerialNo, 
				 	FileAction, 	
				 	FileActionMemo,	
				 	FileActionServer,	
				 	OfficerUserid, 
				 	OfficerLastName, 
				 	OfficerFirstName
				)
			VALUES
				(
					'#AttachmentId#',
				 	'1',
					'insert',		
				 	'',	
				 	'#protocol#://#CGI.HTTP_HOST#/',
				 	'#UserAcc#',
					'#UserLast#',
					'#UserFirst#'
				) 
				 
		</cfquery>
		
	</cfif>
    
</cfif>