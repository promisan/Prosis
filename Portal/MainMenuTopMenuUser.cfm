
<cfparam name="url.dashboard" default="0">
<cfquery name="getUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     UserNames
		WHERE    Account = '#SESSION.acc#'						
   </cfquery>

<cfif url.backOfficeStyle  eq "HTML5">
	
  <!--- Switch IT --->
  <div id="user">
  <div class="user-left">
    <div id="userPic">
      <div id="Pic">
	  	<cf_userProfilePicture height="auto" width="80px">
      </div>
    </div>
  </div>  
  
</cfif>
 
  <cfoutput> 
  <div class="user-right">
  <div id="navigation">
    <ul class="top-level">
	
      <!--- <li> <a onclick="milload()" href="javascript:ptoken.location('#SESSION.root#/Portal/Preferences/UserEdit.cfm?ID=#SESSION.acc#','portalright');"> <img src="#SESSION.root#/Images/preferences_small.png">
        <cf_tl id="Preferences">
        </a> </li> --->		
		
		<cftry>

	        <cfquery name="Portal" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   R.*
					FROM     xl#Client.LanguageId#_Ref_ModuleControl R
					WHERE    R.SystemModule   =  'Portal'
					AND      R.FunctionClass  =  'Portal' 
					AND      R.Operational    =  '1'
					AND      R.MenuClass      =  'Menu'
					AND		 R.FunctionName   =  'My Profile'
					ORDER BY R.FunctionClass, R.MenuOrder  
			</cfquery>
			
        <cfcatch>
    
	      <cfinclude template="../system/language/View/Init.cfm">
		  
          <cfquery name="Portal" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						SELECT   R.*
						FROM     xl#Client.LanguageId#_Ref_ModuleControl R
						WHERE    R.SystemModule   =  'Portal'
						AND      R.FunctionClass  =  'Portal' 
						AND      R.Operational    =  '1'
						AND      R.MenuClass      =  'Menu'
						AND		 R.FunctionName   =  'My Profile'
						ORDER BY R.FunctionClass, R.MenuOrder  
				</cfquery>
        </cfcatch>
		
      </cftry>
	  
      <cfif Portal.recordcount neq "0">
       <!---  <li> <a><img src="images/Maximize_menu.png">
          <cf_tl id="Utilities">
          </a>
          <ul class="sub-level"> --->
            <cfloop query="Portal">
              <cfset condition = FunctionCondition>
              <cfset Mode      = ScriptConstant>
              <cfset Heading   = "">
              <cfif FunctionPath neq "">
                <li class="menuitemlabel my-profile"> <a href="javascript:loadformI('#FunctionPath#','#condition#','#FunctionTarget#','#FunctionDirectory#','#systemFunctionId#','#Heading#','#EnforceReload#','#FunctionVirtualDir#')"> #FunctionName# </a> </li>
                <cfelse>
                <li class="menuitemlabel my-profile"> <a href="javascript:#ScriptName#('#mode#','#systemFunctionId#','#Heading#','#EnforceReload#')"> #FunctionName# </a> </li>
              </cfif>
            </cfloop>
          <!--- </ul>
        </li> --->
      </cfif>
	  
	  <li class="menuitemlabel supportticket">
		<a href="javascript:supportticket('');">
			<cf_tl id="Submit a Ticket">
		</a>
	  </li>
      
      <cfif getUser.Pref_Timesheet eq "1" and client.PersonNo neq "">
        <li class="menuitemlabel time-sheet"> <a onclick="milload()" href="javascript:ptoken.location('#SESSION.root#/Attendance/Application/Timesheet/TimeSheet.cfm?caller=backoffice&ID=#CLIENT.personNo#','portalright');">
          <cf_tl id="Time sheet">
          </a> </li>
      </cfif>
	  <cfif getAdministrator("*") eq "1">
      <li class="menuitemlabel system-usage"> <a onclick="milload()" href="javascript:ptoken.location('#SESSION.root#/Portal/Activity/UserAction.cfm','portalright');">
        <cf_tl id="System Usage">
        </a> </li>		
	  </cfif>	
      <cfif url.dashboard eq "0">
        <li class="menuitemlabel gadgets"> <a onclick="milload()" href="#SESSION.root#/portal/Topics/PortalTopicsAdd.cfm" target="portalright">
          <cf_tl id="Gadgets">
          </a> </li>
      <cfelse>
        <li class="menuitemlabel Topics"> <a onclick="milload()" href="javascript:toggle('dashboard')">
          <cf_tl id="Topics">
          </a> </li>
        <li class="menuitemlabel Reports"> <a onclick="milload()" href="javascript:toggle('report')"> 
          <cf_tl id="My Favorite Reports" class="message">
          </a> </li>
        <li class="menuitemlabel My-Settings"> <a onclick="milload()" href="javascript:setting()"> 
          <cf_tl id="My Settings" class="message">
          </a> </li>
      </cfif>
	  
	  <cfif getUser.enforceLDAP eq "0">
	  
      <li class="menuitemlabel set-password"> <a onclick="milload(); setpassword()"> 
        <cf_tl id="Set Password">
        </a> </li>
      <!--- <li class="menuitemlabel help"> <a onclick="milload('no'); $('##helpwizarddialog').fadeIn(600); ColdFusion.navigate('widgets/HelpWizard/HelpWizard.cfm','helpwizarddialog')">
        <cf_tl id="Help Wizard">
        </a> </li> --->
		
	  </cfif>
	  
	  <cfif getAdministrator("*") eq "1">
	  	
      <li class="menuitemlabel Selfservice"> <a onclick="milload();" href="javascript:ptoken.location('#SESSION.root#/Portal/PortalListing.cfm?header=0','portalright');">
        <cf_tl id="Selfservice">
        </a> </li>
		
	   </cfif>	
		
     
	  
      <!--- <cfset s = 0>
      <cfloop index="itm" list="Links" delimiters=",">
        <cf_tl id="#itm#" var="1">
        <cfset s = s+1>
        <cfquery name="Links" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM PortalLinks 
				WHERE Class = '#itm#'
				AND (HostNameList is NULL or HostNameList = '' OR HostNameList LIKE '%#CGI.HTTP_HOST#%')
				ORDER BY ListingOrder
		</cfquery>
        <cfif links.recordcount gte "1">
          <li> <a id="s#s#"><img src="images/Maximize_menu.png">#lt_text#</a>
            <ul class="sub-level">
              <cfloop query="Links">
                <cfif locationString eq "">
                  <li> <a onclick="milload()" href="#LocationURL#" target="#LocationTarget#" id="s#s#_#currentrow#"> <img src="#SESSION.root#/Images/bullet.png"> #Description# </a> </li>
                  <cfelse>
                  <li> <a onclick="milload()" href="#LocationURL#?#LocationString#" target="#LocationTarget#" id="s#s#_#currentrow#"> <img src="#SESSION.root#/Images/bullet.png"> #Description#</a></li>
                </cfif>
              </cfloop>
            </ul>
          </li>
        </cfif>
      </cfloop> --->
	  
	  
    </ul>
  </div>
  </cfoutput> 
  </div>