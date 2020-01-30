
<cfsavecontent variable="menu">
		
	<cfmenu name="maninfo"
          font="verdana"
          fontsize="9"
          type="horizontal"
          bgcolor="transparent"
          selectedfontcolor="808080">
				  	  		 		 		 		 		  		  
		  <cfmenuitem 
          display="My Favorite Reports"
          name="menureport"
          href="javascript:toggle('report')"
          image="#SESSION.root#/Images/favorite.gif"/>
		  		  
		 <cfmenuitem 
          display="My Settings"
          name="menusetting"
          href="javascript:setting()"
          image="#SESSION.root#/Images/config.gif"/>
		 	
	</cfmenu>	
	
</cfsavecontent>	

<cf_ViewTopMenu option="#menu#" background="linesBlue" layout="webapp" label="#session.welcome# Presenter">	

	
	
	