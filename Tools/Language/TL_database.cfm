<!--- retrieve from database --->
	
<!--- step 1 we check if there is an application server specific language label --->
	
<!--- specific for this site --->
<cfparam name="url.languageCodeDB" 	default="ENG">
<cfparam name="#CLIENT.LanguageId#" default="ENG">
<cfif CLIENT.LanguageId eq "">
	<cfset CLIENT.LanguageId = "ENG">
</cfif>

<cfquery name="qSelect" 
datasource="AppsInit">		
	SELECT Text#url.languageCodeDB# as Label, lastUsedDate
	FROM   InterfaceSite
	WHERE  ApplicationServer = (SELECT ApplicationServer 
	                            FROM   Parameter 
								WHERE  HostName = '#CGI.HTTP_HOST#')									
	AND    TextClass         = '#Attributes.Class#'
	AND    TextId            = '#Attributes.Id#'			
</cfquery>
	
<cfif qSelect.recordcount eq "0">

	<!--- then we check one level up which is generic --->
		
	<cfquery name="qSelect" 
	datasource="AppsInit">
		SELECT Text#url.languageCodeDB# as Label, lastUsedDate
		FROM   InterfaceText
		WHERE  TextClass = '#Attributes.Class#'
		AND    TextId    = '#Attributes.Id#'
	</cfquery>			
	<!--- ------------------------------------ --->
	<!--- this portion will usually not happen --->
	<!--- ------------------------------------ --->
		 
	<cfif qSelect.recordcount eq "0">
	
		 <!--- add an entry check for a new label --->
	 
		 <cfquery name="Insert" 
		  datasource="AppsInit">
		  INSERT INTO InterfaceText
		       (TextClass,
			    TextId,
				TextENG,
				OfficerUserId,
				LastUsedUserid,
				LastUsedDate)
		  VALUES
			   ('#Attributes.Class#',
			    '#Attributes.Id#',
				'#Attributes.id#',
				'#SESSION.acc#',
				'#SESSION.acc#',
				getDate())
		 </cfquery>
		 
		 <cfquery name="qSelect" 
		 datasource="AppsInit">
			  SELECT Text#url.languageCodeDB# as Label, lastUsedDate
			  FROM   InterfaceText
			  WHERE  TextClass = '#Attributes.Class#'
			  AND    TextId    = '#Attributes.Id#'
		</cfquery>
		
	<cfelse>		
		
		  <!--- This can be done if and only if the session is valid --->
		  
		  <cftry>
		
				<cfif dateformat(qSelect.lastUsedDate,"DDMMYY") 
				      neq dateformat(now(),"DDMMYY")>
			
					 <cfquery name="Update" 
					 datasource="AppsInit">
						  UPDATE InterfaceText
						  SET    LastUsedUserid = '#SESSION.acc#',
								 LastUsedDate   = getDate()
						  WHERE  TextClass      = '#Attributes.Class#'
						  AND    TextId         = '#Attributes.Id#'
					</cfquery>
				
				</cfif>
		
			<cfcatch>				
				<!--- nada as the session is expired --->	
					
			</cfcatch>		
		
	 	  </cftry>
		
	</cfif>	 
	
	<!--- --------------------------------- --->
	<!--- --------------------------------- --->
			
</cfif>	
  