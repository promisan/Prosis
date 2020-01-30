<script>

<cfoutput>

function recordadd(code) {
          window.open("#SESSION.root#/CaseFile/maintenance/CaseFileTabs/RecordAdd.cfm?id1="+code, "AddTab", "left=80, top=80, width= 700, height= 480, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2,id3) {
          window.open("#SESSION.root#/CaseFile/maintenance/CaseFileTabs/RecordEdit.cfm?ID1="+id1+"&ID2="+id2+"&ID3="+id3, "EditTab","left=80, top=80, unadorned:yes; edge:raised; status:yes; dialogHeight:480px; dialogWidth:640px; help:no; scroll:no; center:yes; resizable:no");
}

</cfoutput>
</script>	