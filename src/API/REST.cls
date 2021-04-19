/// Description
Class API.REST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/subjects" Method="GET" Call="GetSubjects"/>
	<Route Url="/subjects" Method="POST" Call="AddSubject"/>
	<Route Url="/teachers" Method="GET" Call="GetTeachers"/>
	<Route Url="/teachers" Method="POST" Call="AddTeacher"/>
	<Route Url="/students" Method="GET" Call="GetStudents"/>
	<Route Url="/students" Method="POST" Call="AddStudent"/>
	<Route Url="/meeting" Method="POST" Call="AddMeeting"/>
	<Route Url="/teachers/:teacherId/meetings" Method="GET" Call="GetTeacherMeetings"/>




	<!-- <Route Url="/addStudent" Method="POST" Call="AddStudent"/>
	<Route Url="/addTeacher" Method="POST" Call="AddTeacher"/>
	<Route Url="/getSubjects" Method="GET" Call="GetSubjects"/>
	<Route Url="/test" Method="GET" Call="Test"/>
	<Route Url="/login" Method="POST" Call="signUp"/>
	<Route Url="/getDoctors" Method="GET" Call="getDoctors"/>
	<Route Url="/doctors/:idDoctor" Method="GET" Call="getDoctor"/>
	<Route Url="/doctors/:idDoctor" Method="GET" Call="getDoctor"/>
	<Route Url="/patient" Method="GET" Call="patientByEmail"/>
	<Route Url="/appointments" Method="POST" Call="makeAppointment"/> -->

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
		"teacherId": (teacher.%Id()),
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
		"studentId": (student.%Id()),
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
		"subjectId": (subject.%Id()),
		"subjectName": (subject.subjectName)
	}
	Write cSubject.%ToJSON()
	Return sc
}

ClassMethod Test() As %Status
{
	Set currentDate = $ZDATE($NOW(), 3)
	Set obj = {"msg":"It works","today": (currentDate)}
	Write obj.%ToJSON()
	Return $$$OK
}

ClassMethod getDoctors() As %Status
{
	Set sc = $$$OK
	Set sql = "select JSON_OBJECT('ID': ID, 'FIO':FIO, 'birthDate':birthDate, 'email': email, 'phone': phone) as doctor FROM Dentistry.Doctor"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, sql)
	Set obj = {"doctors": []}

	while rs.%Next() {
		Set doctor = {}.%FromJSON(rs.doctor)
		Do obj.doctors.%Push(doctor)
	}
	Write obj.%ToJSON()
	Return sc
}

ClassMethod signUp() As %Status
{
	Set sc = $$$OK
	try{
		set jo = {}.%FromJSON(%request.Content)
		set client = ##class(Dentistry.Patient).%New()
		set client.FIO = jo.FIO
		set client.birthDate = $ZDATEH(jo.birthDate, 3)
		set client.email = jo.email
		set client.phone = jo.phone
		set sc = client.%Save()
	} catch ex {
		Set errText = $SYSTEM.Status.GetErrorText(ex.AsStatus())
		Write errText
		return ex
	}
	Return sc
}

ClassMethod getDoctor(idDoctor As %Integer) As %Status
{
	Set sc = $$$OK
	Set doctor = ##class(Dentistry.Doctor).%OpenId(idDoctor)
	Set d = {"schedules": []}
	Set key = ""
	Do {
		Set schedule = doctor.schedules.GetNext(.key)
		If (schedule '= "") {
			Set sch = {"date": (schedule.date)}
			Do d.schedules.%Push(sch)
		}
	} While (key '= "")

	Set dDoctor = {
		"ID": (doctor.%Id()),
		"FIO": (doctor.FIO),
		"birthDate": (doctor.birthDate), 
		"education": (doctor.education), 
		"email": (doctor.email), 
		"experience": (doctor.experience), 
		"phone": (doctor.phone)
	}
	Set d.doctor = dDoctor

	Write d.%ToJSON()
	Return sc
}

ClassMethod patientByEmail() As %Status
{
	Set sc = $$$OK
	Set FormEmail = $GET(%request.Data("email", 1))
	Set pat = ##class(Dentistry.Patient).emailKeyOpen(FormEmail)
	Set pPat = {
		"FIO": (pat.FIO), 
		"birthDate": (pat.birthDate), 
		"medicalHistory": (pat.medicalHistory), 
		"email": (pat.email), 
		"addInfo": (pat.addInfo), 
		"phone": (pat.phone)
	}
	
	
	Set p = {"appointments": [], "patient": (pPat)}
	Set key = ""
	Do {
		Set appointment = pat.appointments.GetNext(.key)
		If (appointment '= "") {
			Set doctor = appointment.doctor
			Set dDoctor = {
				"FIO": (doctor.FIO),
				"birthDate": (doctor.birthDate),
				"education": (doctor.education),
				"email": (doctor.email),
				"experience": (doctor.experience),
				"phone": (doctor.phone)
			}
			Set sch = {"date": (appointment.date), "doctor": (dDoctor)}
			Do p.appointments.%Push(sch)
		}
	} While (key '= "")

	Write p.%ToJSON()

	Return sc
}

ClassMethod makeAppointment() As %Status
{
	Set sc = $$$OK
	set jo = {}.%FromJSON(%request.Content)
	Set pat = ##class(Dentistry.Patient).emailKeyOpen(jo.userEmail)

	Set appointment = ##class(Dentistry.Appointment).%New()

	set appointment.date = jo.date

	Do appointment.patientSetObjectId(pat.%Id())
	Do appointment.doctorSetObjectId(jo.doctorId)
	Do appointment.%Save()

	Return sc
}

}
