/// Description
Class API.REST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/test" Method="GET" Call="Test"/>
	<Route Url="/subjects" Method="GET" Call="GetSubjects"/>
	<Route Url="/subjects" Method="POST" Call="AddSubject"/> 
	<Route Url="/teachers" Method="GET" Call="GetTeachers"/>
	<Route Url="/teachers" Method="POST" Call="AddTeacher"/>
	<Route Url="/students" Method="GET" Call="GetStudents"/>
	<Route Url="/students" Method="POST" Call="AddStudent"/>
	<Route Url="/meetings" Method="POST" Call="AddMeeting"/>
	<Route Url="/meetings/:meetingId/delete" Method="GET" Call="DeleteMeeting"/>
	<Route Url="/teachers/:teacherId/meetings" Method="GET" Call="GetTeacherMeetings"/>

</Routes>
}

ClassMethod AddTeacher() As %Status
{
	Set sc = $$$OK
	Try {
		set jo = {}.%FromJSON(%request.Content)
		set teacher = ##class(Educational.Teacher).%New()
		set teacher.name = jo.name
		set teacher.email = jo.email
		set teacher.yearsExperience = jo.yearsExperience
		set sc = teacher.%Save()
	} catch ex {
		Set errText = $SYSTEM.Status.GetErrorText(ex.AsStatus())
		Write errText
		return ex
	}

	Set cTeacher = {
		#; ($NUM(student.%Id()))
		"teacherId": ($NUM(teacher.%Id())),
		"name": (teacher.name),
		"email": (teacher.email),
		"yearsExperience": (teacher.yearsExperience)
	}
	Write cTeacher.%ToJSON()
	Return sc
}

ClassMethod AddStudent() As %Status
{
	Set sc = $$$OK
	Try {
		set jo = {}.%FromJSON(%request.Content)
		set student = ##class(Educational.Student).%New()
		set student.name = jo.name
		set student.email = jo.email
		set student.age = jo.age
		set sc = student.%Save()
	} catch ex {
		Set errText = $SYSTEM.Status.GetErrorText(ex.AsStatus())
		Write errText
		return ex
	}

	Set cStudent = {
		"studentId": ($NUM(student.%Id())),
		"name": (student.name),
		"email": (student.email),
		"age": (student.age)
	}
	Write cStudent.%ToJSON()
	Return sc
}

ClassMethod AddSubject() As %Status
{
	Set sc = $$$OK
	Try {
		set jo = {}.%FromJSON(%request.Content)
		set subject = ##class(Educational.Subject).%New()
		set subject.subjectName = jo.subjectName
		set sc = subject.%Save()
	} catch ex {
		Set errText = $SYSTEM.Status.GetErrorText(ex.AsStatus())
		Write errText
		return ex
	}

	Set cSubject = {
		"subjectName": (subject.subjectName),
		"subjectId": ($NUM(subject.%Id()))
	}
	Write cSubject.%ToJSON()
	Return sc
}

ClassMethod AddMeeting() As %Status
{
	Set sc = $$$OK
	Try {
		set jo = {}.%FromJSON(%request.Content)

		set meeting = ##class(Educational.Meeting).%New()
		set meeting.title = jo.title
		set meeting.time = jo.time

		Do meeting.teacherSetObjectId(jo.teacherId)
		Do meeting.studentSetObjectId(jo.studentId)
		Do meeting.subjectSetObjectId(jo.subjectId)

		set sc = meeting.%Save()

		Set cMeeting = {
			"meetingId": ($NUM(meeting.%Id())),
			"title": (meeting.title),
			"time": (meeting.time),
			"teacherId": (jo.teacherId),
			"studentId": (jo.studentId),
			"subjectId": (jo.subjectId)
		}
		Write cMeeting.%ToJSON()

	} catch ex {
		Set errText = $SYSTEM.Status.GetErrorText(ex.AsStatus())
		Write errText
		return ex
	}

	Return sc
}

ClassMethod GetTeacherMeetings(teacherId As %Integer) As %Status
{
	Set sc = $$$OK
	Set sql = "select JSON_OBJECT('teacherId': teacher, 'studentId': student, 'title': title, 'time': ""time"", 'meetingId': ID) as meeting FROM Educational.Meeting WHERE teacher = ?"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, teacherId)
	Set obj = {"meetings": []}

	while rs.%Next() {
		Set meeting = {}.%FromJSON(rs.meeting)
		Do obj.meetings.%Push(meeting)
	}
	Write obj.%ToJSON()
	Return sc
}

ClassMethod DeleteMeeting(meetingId As %Integer) As %Status
{
	Set sc = $$$OK
	Set meeting = ##class(Educational.Meeting).%OpenId(meetingId)
	Set sql = "DELETE FROM Educational.Meeting WHERE ID = ?"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, meetingId)

	Set cMeeting = {
		"meetingId": ($NUM(meeting.%Id())),
		"title": (meeting.title),
		"time": (meeting.time)
	}
	Write cMeeting.%ToJSON()

	Return sc
}

ClassMethod GetSubjects() As %Status
{
	Set sc = $$$OK
	Set sql = "select JSON_OBJECT('subjectId': ID, 'subjectName': subjectName) as subject FROM Educational.Subject"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, sql)
	Set obj = {"subjects": []}

	while rs.%Next() {
		Set subject = {}.%FromJSON(rs.subject)
		Do obj.subjects.%Push(subject)
	}
	Write obj.%ToJSON()
	Return sc
}

ClassMethod GetTeachers() As %Status
{
	Set sc = $$$OK
	Set sql = "select JSON_OBJECT('teacherId': ID, 'email': email, 'name': name, 'yearsExperience': yearsExperience) as teacher FROM Educational.Teacher"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, sql)
	Set obj = {"teachers": []}

	while rs.%Next() {
		Set teacher = {}.%FromJSON(rs.teacher)
		Do obj.teachers.%Push(teacher)
	}
	Write obj.%ToJSON()
	Return sc
}

ClassMethod GetStudents() As %Status
{
	Set sc = $$$OK
	Set sql = "select JSON_OBJECT('studentId': ID, 'email': email, 'name': name, 'age': age) as student FROM Educational.Student"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, sql)
	Set obj = {"students": []}

	#; Do rs.%Display()

	while rs.%Next() {
		Set student = {}.%FromJSON(rs.student)
		Do obj.students.%Push(student)
	}
	Write obj.%ToJSON()
	Return sc
}

ClassMethod Test() As %Status
{
	Set currentDate = $ZDATE($NOW(), 3)
	Set obj = {"msg":"It works","today": (currentDate)}
	Write obj.%ToJSON()
	Return $$$OK
}

}
