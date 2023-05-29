///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования.
// 
Процедура ЗафиксироватьРезультатВыполненияРассылкиПолучателю(ПоляИстории) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИсторияРассылкиОтчетов");
		ЭлементБлокировки.УстановитьЗначение("РассылкаОтчетов", ПоляИстории.РассылкаОтчетов);
		ЭлементБлокировки.УстановитьЗначение("Получатель", ПоляИстории.Получатель);
		ЭлементБлокировки.УстановитьЗначение("ЗапускРассылки", ПоляИстории.ЗапускРассылки);
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		МенеджерЗаписи.РассылкаОтчетов = ПоляИстории.РассылкаОтчетов;
		МенеджерЗаписи.Получатель      = ПоляИстории.Получатель;
		МенеджерЗаписи.ЗапускРассылки  = ПоляИстории.ЗапускРассылки; 
		МенеджерЗаписи.УчетнаяЗапись   = ПоляИстории.УчетнаяЗапись;
		МенеджерЗаписи.АдресЭП         = ПоляИстории.АдресЭП;
		МенеджерЗаписи.Период          = ПоляИстории.Период;
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.Комментарий = ?(ЗначениеЗаполнено(МенеджерЗаписи.Комментарий), МенеджерЗаписи.Комментарий + Символы.ПС
			+ ПоляИстории.Комментарий, ПоляИстории.Комментарий);
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПоляИстории, , "Комментарий");

		МенеджерЗаписи.Записать(Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
