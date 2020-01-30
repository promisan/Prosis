
<cfoutput>

<cfset root = SESSION.root>

<script>
	
	var root = "#root#";
	var id2 = "";
	var id3 = "";	
			
	function userlocateN(formname,id,id1,id2,id3,id4) {
		
		wid = document.body.clientWidth-80
		if (wid > 800) {
		  wid = 800
		}
		ColdFusion.Window.create('userdialog', 'User', '',{x:100,y:100,height:document.body.clientHeight-80,width:wid,modal:false,center:true})    
		ColdFusion.Window.show('userdialog') 				
		ColdFusion.navigate(root + '/System/Access/Lookup/UserSearch.cfm?Form=' + formname + '&id=' + id + '&id1=' + id1 + '&id2=' + id2 + '&id3=' + id3 + '&id4=' + id4,'userdialog') 	
	
	}
	
	function memberlocate(form,id ,id1, id2, id3,group) {
	    ptoken.open(root + "/System/Access/Lookup/MemberResult.cfm?form=" + form + "&id=" + id + "&id1=" + id1 + "&id2=" + id2 + "&id3=" + id3 + "&group=" + group, "_blank", "width=740, height=700, status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	function selectuser(form, id , name, last, first) {
	    ptoken.open(root + "/System/Access/Lookup/DialogSearch.cfm?formName=" + form + "&flduserid=" + id + "&fldname=" + name + "&fldlastname=" + last + "&fldfirstname=" + first, "_blank", "width=700, height=500, status=yes, toolbar=yes, scrollbars=yes, resizable=no");
	}
	
	function SearchPerson(formname, fieldname) {
		ptoken.open(root + "/DWarehouse/Search/IndexSearch.cfm?FormName=" + formname + "&FieldName=" + fieldname, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function ShowUser(Account) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 100;
		ptoken.open(root + "/System/Access/User/UserDetail.cfm?ID=" + Account + "&ID1=" + h + "&ID2=" + w, "_blank");
	}
	
	function ShowUserRole(Account) {
	    w = #CLIENT.width# - 150;
	    h = #CLIENT.height# - 130;
		ptoken.open(root + "/System/Access/User/UserAccessListing.cfm?ID=" + Account + "&ID1=" + h + "&ID2=" + w, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	</script>

</cfoutput>