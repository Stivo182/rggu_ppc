///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегламентноеЗаданиеGUID");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьСценарий(
		УзелИнформационнойБазы,
		Расписание = Неопределено,
		ИспользоватьРегламентноеЗадание = Истина) Экспорт
	
	Отказ = Ложь;
	
	Наименование = НСтр("ru = 'Автоматическая синхронизация данных с %1'");
	Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Наименование,
			Строка(УзелИнформационнойБазы));
	
	ВидТранспортаОбмена = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	СценарийОбменаДанными = СоздатьЭлемент();
	
	// Заполняем реквизиты шапки
	СценарийОбменаДанными.Наименование = Наименование;
	СценарийОбменаДанными.ИспользоватьРегламентноеЗадание = ИспользоватьРегламентноеЗадание;
	
	// Создаем регламентное задание.
	ОбновитьДанныеРегламентногоЗадания(Отказ, Расписание, СценарийОбменаДанными);
	
	// Табличная часть
	СтрокаТаблицы = СценарийОбменаДанными.НастройкиОбмена.Добавить();
	СтрокаТаблицы.ВидТранспортаОбмена = ВидТранспортаОбмена;
	СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	СтрокаТаблицы = СценарийОбменаДанными.НастройкиОбмена.Добавить();
	СтрокаТаблицы.ВидТранспортаОбмена = ВидТранспортаОбмена;
	СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	СценарийОбменаДанными.Записать();
	
КонецПроцедуры

Функция РасписаниеРегламентногоЗаданияПоУмолчанию() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	Расписание.Месяцы                   = Месяцы;
	
	Возврат Расписание;
КонецФункции

// Получает расписание регламентного задания.
// Если регламентное задание не задано, то возвращает пустое расписание (по умолчанию).
//
Функция ПолучитьРасписаниеВыполненияОбменаДанными(НастройкаВыполненияОбмена) Экспорт
	
	РегламентноеЗаданиеОбъект = РегламентноеЗаданиеПоИдентификатору(НастройкаВыполненияОбмена.РегламентноеЗаданиеGUID);
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		
	Иначе
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции

Процедура ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(ТекущийОбъект.Код) Тогда	
		ТекущийОбъект.УстановитьНовыйКод();		
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		СоздатьОбновитьРегламентноеЗаданиеВСервисе(РасписаниеРегламентногоЗадания, ТекущийОбъект);	
		
	Иначе
	
		// Получаем регламентное задание по идентификатору, если объект не находим, то создаем новый.
		РегламентноеЗаданиеОбъект = СоздатьРегламентноеЗаданиеПриНеобходимости(Отказ, ТекущийОбъект);
				
		// обновляем свойства РЗ
		УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект);
		
		// Записываем измененное задание.
		ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект);
		
		// Запоминаем GUID регламентное задания в реквизите объекта.
		ТекущийОбъект.РегламентноеЗаданиеGUID = Строка(РегламентноеЗаданиеОбъект.УникальныйИдентификатор);
	
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьРегламентноеЗаданиеПриНеобходимости(Отказ, ТекущийОбъект)
	
	РегламентноеЗаданиеОбъект = РегламентноеЗаданиеПоИдентификатору(ТекущийОбъект.РегламентноеЗаданиеGUID);
	
	// При необходимости создаем регламентное задание.
	Если РегламентноеЗаданиеОбъект = Неопределено Тогда
		ПараметрыЗадания = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияДанных);
		РегламентноеЗаданиеОбъект = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

Процедура УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект)
		
	ПараметрыРегламентногоЗадания = Новый Массив;
	ПараметрыРегламентногоЗадания.Добавить(ТекущийОбъект.Код);
	
	НаименованиеРегламентногоЗадания = НСтр("ru = 'Выполнение обмена по сценарию: %1'");
	НаименованиеРегламентногоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеРегламентногоЗадания, СокрЛП(ТекущийОбъект.Наименование));
	
	РегламентноеЗаданиеОбъект.Наименование  = Лев(НаименованиеРегламентногоЗадания, 120);
	РегламентноеЗаданиеОбъект.Использование = ТекущийОбъект.ИспользоватьРегламентноеЗадание;
	РегламентноеЗаданиеОбъект.Параметры     = ПараметрыРегламентногоЗадания;
	
	// Обновляем расписание, если оно было изменено.
	Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
		РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет запись регламентного задания.
//
// Параметры:
//  Отказ                     - Булево - флаг отказа. Если в процессе выполнения процедуры были обнаружены ошибки,
//                                       то флаг отказа устанавливается в значение Истина.
//  РегламентноеЗаданиеОбъект - объект регламентного задания, которое необходимо записать.
// 
Процедура ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		// записываем задание
		РегламентноеЗаданиеОбъект.Записать();
		
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Произошла ошибка при сохранении расписания выполнения обменов. Подробное описание ошибки: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбменДаннымиСервер.СообщитьОбОшибке(СтрокаСообщения, Отказ);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура СоздатьОбновитьРегламентноеЗаданиеВСервисе(РасписаниеРегламентногоЗадания, ТекущийОбъект)
	
	ЗаданиеОбъект = Неопределено;
	Если ЗначениеЗаполнено(ТекущийОбъект.РегламентноеЗаданиеGUID) Тогда
		ЗаданиеGUID = Новый УникальныйИдентификатор(ТекущийОбъект.РегламентноеЗаданиеGUID);
		ЗаданиеОбъект = РегламентныеЗаданияСервер.Задание(ЗаданиеGUID);
	КонецЕсли;
		
	Если ЗаданиеОбъект = Неопределено Тогда
		
		ПараметрыПроцедуры = Новый Массив;
		ПараметрыПроцедуры.Добавить(ТекущийОбъект.Код);
		
		Ключ = ЗаданиеGUID;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Ключ", Лев(Ключ, 120));
		ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВнутренняяПубликация.ВыполнитьОбменДаннымиПоСценарию");
		ПараметрыЗадания.Вставить("ОбластьДанных", ПараметрыСеанса["ОбластьДанныхЗначение"]);
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяДатаСеанса());
		ПараметрыЗадания.Вставить("Параметры", ПараметрыПроцедуры);	
		ПараметрыЗадания.Вставить("Использование", ТекущийОбъект.ИспользоватьРегламентноеЗадание);
		
		Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
			ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
		КонецЕсли;
		
		МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
		ЗаданиеОбъект = МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
		ЗаданиеGUID = ЗаданиеОбъект.УникальныйИдентификатор();
		
	Иначе
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", ТекущийОбъект.ИспользоватьРегламентноеЗадание);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяДатаСеанса());
		
		Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
			ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
		КонецЕсли;
		
		МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
		МодульОчередьЗаданий.ИзменитьЗадание(ЗаданиеОбъект.Идентификатор, ПараметрыЗадания);

	КонецЕсли;
		
	ТекущийОбъект.РегламентноеЗаданиеGUID = Строка(ЗаданиеGUID);

КонецПроцедуры

// Возвращает регламентное задание по GUID.
//
// Параметры:
//  УникальныйНомерЗадания - Строка - строка с GUID регламентного задания.
// 
// Возвращаемое значение:
//  Неопределено        - если поиск регламентного задания по GUID не дал результатов, или
//  РегламентноеЗадание - найденное по GUID регламентное задание.
//
Функция РегламентноеЗаданиеПоИдентификатору(Знач УникальныйНомерЗадания) Экспорт
	
	Если ПустаяСтрока(УникальныйНомерЗадания) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(УникальныйНомерЗадания));
	
	УстановитьПривилегированныйРежим(Истина);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	Если Задания.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат Задания[0];
	
КонецФункции

// Удаляет узел из всех сценариев обменов данными.
// Если после этого сценарий оказывается пустым, то такой сценарий удаляется.
//
Процедура ОчиститьСсылкиНаУзелИнформационнойБазы(Знач УзелИнформационнойБазы) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК СценарийОбменаДанными
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы");
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	ТаблицаСценарии = Запрос.Выполнить().Выгрузить();
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.СценарииОбменовДанными");
    	ЭлементБлокировки.ИсточникДанных = ТаблицаСценарии;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "СценарийОбменаДанными");
		Блокировка.Заблокировать();
		
		Для Каждого СтрокаСценарии Из ТаблицаСценарии Цикл
			ЗаблокироватьДанныеДляРедактирования(СтрокаСценарии.СценарийОбменаДанными);
			СценарийОбменаДанными = СтрокаСценарии.СценарийОбменаДанными.ПолучитьОбъект(); // СправочникОбъект.СценарииОбменовДанными
			
			УдалитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы);
			УдалитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы);
			
			СценарийОбменаДанными.Записать();
			
			Если СценарийОбменаДанными.НастройкиОбмена.Количество() = 0 Тогда
				СценарийОбменаДанными.Удалить();
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	УдалитьСтрокуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	
КонецПроцедуры

Процедура УдалитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	УдалитьСтрокуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	
КонецПроцедуры

Процедура ДобавитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	Если ТипЗнч(СценарийОбменаДанными) = Тип("СправочникСсылка.СценарииОбменовДанными") Тогда
		НачатьТранзакцию();
		Попытка
		    Блокировка = Новый БлокировкаДанных;
		    ЭлементБлокировки = Блокировка.Добавить("Справочник.СценарииОбменовДанными");
		    ЭлементБлокировки.УстановитьЗначение("Ссылка", СценарийОбменаДанными);
		    Блокировка.Заблокировать();
		    
			ЗаблокироватьДанныеДляРедактирования(СценарийОбменаДанными);
			СценарийОбъект = СценарийОбменаДанными.ПолучитьОбъект();
			
			ДобавитьСтрокиНастроекОбменаПоСценарию(
				СценарийОбъект.НастройкиОбмена, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);

		    СценарийОбъект.Записать();

		    ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	Иначе
		ДобавитьСтрокиНастроекОбменаПоСценарию(
			СценарийОбменаДанными.НастройкиОбмена, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	Если ТипЗнч(СценарийОбменаДанными) = Тип("СправочникСсылка.СценарииОбменовДанными") Тогда
		НачатьТранзакцию();
		Попытка
		    Блокировка = Новый БлокировкаДанных;
		    ЭлементБлокировки = Блокировка.Добавить("Справочник.СценарииОбменовДанными");
		    ЭлементБлокировки.УстановитьЗначение("Ссылка", СценарийОбменаДанными);
		    Блокировка.Заблокировать();
		    
			ЗаблокироватьДанныеДляРедактирования(СценарийОбменаДанными);
			СценарийОбъект = СценарийОбменаДанными.ПолучитьОбъект();
			
			ДобавитьСтрокиНастроекОбменаПоСценарию(
				СценарийОбъект.НастройкиОбмена, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);

		    СценарийОбъект.Записать();

		    ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	Иначе
		ДобавитьСтрокиНастроекОбменаПоСценарию(
			СценарийОбменаДанными.НастройкиОбмена, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСтрокиНастроекОбменаПоСценарию(
		НастройкиОбмена, УзелИнформационнойБазы, ВыполняемоеДействие)
		
	ВидТранспортаОбмена = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	Если ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ВыгрузкаДанных Тогда
		// Добавляем выгрузку данных в цикле.
		МаксимальныйИндекс = НастройкиОбмена.Количество() - 1;
		
		Для Индекс = 0 По МаксимальныйИндекс Цикл
			
			ОбратныйИндекс = МаксимальныйИндекс - Индекс;
			
			СтрокаТаблицы = НастройкиОбмена[ОбратныйИндекс];
			
			// последняя строка выгрузки
			Если СтрокаТаблицы.ВыполняемоеДействие = ВыполняемоеДействие Тогда
				
				НоваяСтрока = НастройкиОбмена.Вставить(ОбратныйИндекс + 1);
				
				НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
				НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
				НоваяСтрока.ВыполняемоеДействие    = ВыполняемоеДействие;
				
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		// Если в цикле строка выгрузки не была добавлена, то вставляем строку в конец таблицы.
		Отбор = Новый Структура("УзелИнформационнойБазы, ВыполняемоеДействие", УзелИнформационнойБазы, ВыполняемоеДействие);
		Если НастройкиОбмена.НайтиСтроки(Отбор).Количество() = 0 Тогда
			
			НоваяСтрока = НастройкиОбмена.Добавить();
			
			НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
			НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
			НоваяСтрока.ВыполняемоеДействие    = ВыполняемоеДействие;
			
		КонецЕсли;
	ИначеЕсли ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ЗагрузкаДанных Тогда
		// Добавляем загрузку данных в цикле.
		Для каждого СтрокаТаблицы Из НастройкиОбмена Цикл
			
			Если СтрокаТаблицы.ВыполняемоеДействие = ВыполняемоеДействие Тогда // первая строка загрузки
				
				НоваяСтрока = НастройкиОбмена.Вставить(НастройкиОбмена.Индекс(СтрокаТаблицы));
				
				НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
				НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
				НоваяСтрока.ВыполняемоеДействие    = ВыполняемоеДействие;
				
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		// Если в цикле строка загрузки не была добавлена, то вставляем строку в начало таблицы.
		Отбор = Новый Структура("УзелИнформационнойБазы, ВыполняемоеДействие", УзелИнформационнойБазы, ВыполняемоеДействие);
		Если НастройкиОбмена.НайтиСтроки(Отбор).Количество() = 0 Тогда
			
			НоваяСтрока = НастройкиОбмена.Вставить(0);
			
			НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
			НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
			НоваяСтрока.ВыполняемоеДействие    = ВыполняемоеДействие;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьСтрокуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы, ДействиеПриОбмене)
	
	Если ТипЗнч(СценарийОбменаДанными) = Тип("СправочникСсылка.СценарииОбменовДанными") Тогда
		НачатьТранзакцию();
		Попытка
		    Блокировка = Новый БлокировкаДанных;
		    ЭлементБлокировки = Блокировка.Добавить("Справочник.СценарииОбменовДанными");
		    ЭлементБлокировки.УстановитьЗначение("Ссылка", СценарийОбменаДанными);
		    Блокировка.Заблокировать();
		    
			ЗаблокироватьДанныеДляРедактирования(СценарийОбменаДанными);
			СценарийОбъект = СценарийОбменаДанными.ПолучитьОбъект();
			
			УдалитьСтрокиНастроекОбменаИзСценария(СценарийОбъект.НастройкиОбмена, УзелИнформационнойБазы, ДействиеПриОбмене);

		    СценарийОбъект.Записать();

		    ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	Иначе
		УдалитьСтрокиНастроекОбменаИзСценария(СценарийОбменаДанными.НастройкиОбмена, УзелИнформационнойБазы, ДействиеПриОбмене)
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьСтрокиНастроекОбменаИзСценария(НастройкиОбмена, УзелИнформационнойБазы, ДействиеПриОбмене)
	
	Сч = НастройкиОбмена.Количество() - 1;
	Пока Сч >= 0 Цикл
		
		СтрокаТаблицы = НастройкиОбмена[Сч];
		
		Если СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы
			И СтрокаТаблицы.ВыполняемоеДействие = ДействиеПриОбмене Тогда
			
			НастройкиОбмена.Удалить(Сч);
			
		КонецЕсли;
		
		Сч = Сч - 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли