#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗначенияЗаполнения.Свойство("Подразделение")
	И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Подразделение) Тогда
		Запись.Роль = Перечисления.РолиОтветственныхЛиц.РуководительПодразделения;	
		ЗаблокироватьВыборРоли();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьФорму();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РольПриИзменении(Элемент)
	Если Не КадроваяСтруктураКлиентСервер.ДляРолиОтветственногоЛицаДоступноПодразделение(Запись.Роль) Тогда
		Запись.Подразделение = Неопределено;
	КонецЕсли;
	
	НастроитьФорму();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьФорму()
	Элементы.Подразделение.Видимость = КадроваяСтруктураКлиентСервер.ДляРолиОтветственногоЛицаДоступноПодразделение(Запись.Роль);
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьВыборРоли()
	Элементы.Роль.Доступность = Ложь;
КонецПроцедуры

#КонецОбласти