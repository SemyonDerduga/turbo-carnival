Class Educational.Teacher Extends (%Library.Persistent, %Populate, Educational.Person)
{

Relationship meetings As Educational.Meeting [ Cardinality = many, Inverse = teacher ];

Relationship subjects As Educational.Subject [ Cardinality = many, Inverse = teacher ];

Property info As %Library.String;

Storage Default
{
<Data name="TeacherDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>email</Value>
</Value>
<Value name="4">
<Value>info</Value>
</Value>
<Value name="5">
<Value>phone</Value>
</Value>
</Data>
<DataLocation>^Educational.TeacherD</DataLocation>
<DefaultData>TeacherDefaultData</DefaultData>
<IdLocation>^Educational.TeacherD</IdLocation>
<IndexLocation>^Educational.TeacherI</IndexLocation>
<StreamLocation>^Educational.TeacherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
