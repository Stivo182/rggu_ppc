#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Ответственный = Пользователи.ТекущийПользователь(); 	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти