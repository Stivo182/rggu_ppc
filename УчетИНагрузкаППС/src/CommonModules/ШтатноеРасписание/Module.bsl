#Область ПрограммныйИнтерфейс

// Данные штатного расписания
//
// Параметры:
//   ПараметрыПолучения - см. ПараметрыПолученияШтатногоРасписания
//
// Возвращаемое значение:
//   ТаблицаЗначений - данные штатного расписания:
//       * ШтатноеРасписание - ДокументСсылка.ПроектШтатногоРасписания
//       * УчебныйГод - СправочникСсылка.УчебныеГоды
//       * Подразделение - СправочникСсылка.Подразделения
//       * Преподаватель - СправочникСсылка.ФизическиеЛица
//       * Должность - СправочникСсылка.Должности
//       * ВидЗанятости - ПеречислениеСсылка.ВидыЗанятости
//       * УченоеЗвание - СправочникСсылка.УченыеЗвания
//       * УченаяСтепень - СправочникСсылка.УченыеСтепени
//       * КоличествоСтавок - Число
//       * КоличествоЧасов - Число
//       * ВидЗаписи - СправочникСсылка.ВидыЗаписейШтатногоРасписания
//
Функция ДанныеШтатногоРасписания(ПараметрыПолучения) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	
	СоздатьВТДанныеШтатногоРасписанияПоПараметрам(ПараметрыПолучения, Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ДанныеШтатногоРасписания.ШтатноеРасписание,
	|	ДанныеШтатногоРасписания.УчебныйГод,
	|	ДанныеШтатногоРасписания.Подразделение,
	|	ДанныеШтатногоРасписания.Преподаватель КАК Преподаватель,
	|	ДанныеШтатногоРасписания.Должность КАК Должность,
	|	ДанныеШтатногоРасписания.ВидЗанятости,
	|	ДанныеШтатногоРасписания.УченаяСтепень,
	|	ДанныеШтатногоРасписания.УченоеЗвание,
	|	ДанныеШтатногоРасписания.КоличествоСтавок,
	|	ДанныеШтатногоРасписания.КоличествоЧасов,
	|	ДанныеШтатногоРасписания.ВидЗаписи,
	|	ДанныеШтатногоРасписания.Состояние,
	|	ДанныеШтатногоРасписания.ЗамещаемыйПреподаватель,
	|	ДанныеШтатногоРасписания.ЭтоВакансия
	|ИЗ
	|	ВТДанныеШтатногоРасписания КАК ДанныеШтатногоРасписания
	|
	|УПОРЯДОЧИТЬ ПО
	|	Преподаватель,
	|	Должность
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

// Конструктор структуры для параметра ПараметрыПолучения функции ШтатноеРасписание.СоздатьВТДанныеШтатногоРасписания.
//
// Возвращаемое значение:
//   Структура:
//       * Дата - Дата
//       * УчебныйГод - СправочникСсылка.УчебныеГоды
//       * Подразделение - СправочникСсылка.Подразделения
//       * ИсключаемыйДокумент - ДокументСсылка.ПроектШтатногоРасписания
//
Функция ПараметрыПолученияШтатногоРасписания() Экспорт
	
	Параметры = Новый Структура;	
	
	// Обязательные
	Параметры.Вставить("УчебныйГод", Справочники.УчебныеГоды.ПустаяСсылка());
	
	// Необязательные
	Параметры.Вставить("Дата", Дата(1, 1, 1));
	Параметры.Вставить("Подразделение", Справочники.Подразделения.ПустаяСсылка());
	Параметры.Вставить("ИсключаемыйДокумент", Документы.ПроектШтатногоРасписания.ПустаяСсылка());
	
	Возврат Параметры;

КонецФункции
	
// Формирует временную таблицу ВТДанныеШтатногоРасписания
//
// Параметры:
//		ПараметрыПолучения - см. ПараметрыПолученияШтатногоРасписания
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц
Процедура СоздатьВТДанныеШтатногоРасписанияПоПараметрам(ПараметрыПолучения, МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Период", КонецДня(ПараметрыПолучения.Дата));
	Запрос.УстановитьПараметр("УчебныйГод", ПараметрыПолучения.УчебныйГод);
	Запрос.УстановитьПараметр("Подразделение", ПараметрыПолучения.Подразделение);
	Запрос.УстановитьПараметр("ЕстьПодразделение", ЗначениеЗаполнено(ПараметрыПолучения.Подразделение));
	Запрос.УстановитьПараметр("ИсключаемыйДокумент", ПараметрыПолучения.ИсключаемыйДокумент);
		
	Запрос.Текст = "ВЫБРАТЬ
	|	&Период КАК Период,
	|	&УчебныйГод КАК УчебныйГод,
	|	Подразделения.Ссылка КАК Подразделение,
	|	ЛОЖЬ КАК ТолькоПервичный,
	|	&ИсключаемыйДокумент КАК ИсключаемыйДокумент
	|ПОМЕСТИТЬ ВТПодразделенияШтатногоРасписания
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.Ссылка = &Подразделение
	|	ИЛИ НЕ &ЕстьПодразделение";	
	
	Запрос.Выполнить();
	
	СоздатьВТДанныеШтатногоРасписания(МенеджерВременныхТаблиц);
		
КонецПроцедуры

// Формирует временную таблицу ВТДанныеШтатногоРасписания и ВТШтатноеРасписаниеПодразделений (если отсутствует, 
//	см. СоздатьВТШтатноеРасписаниеПодразделений)
//
// Параметры:
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - должен содержать таблицу
//			ВТПодразделенияШтатногоРасписания или ВТШтатноеРасписаниеПодразделений
//				
//  		Таблица ВТПодразделенияШтатногоРасписания должна содержать поля: 
//  			Период - Дата, 
//  			УчебныйГод - СправочникСсылка.УчебныеГоды, 
//  			Подразделение - СправочникСсылка.Подразделения 
//				ТолькоПервичный - Булево
//				ИсключаемыйДокумент - ДокументСсылка.ПроектШтатногоРасписания	
//					
//			Таблица ВТШтатноеРасписаниеПодразделений должна содержать поля:
//				Период - Дата
//				УчебныйГод - СправочникСсылка.УчебныеГоды
//				Подразделение - СправочникСсылка.Подразделения
//				ТолькоПервичный - Булево
//				ШтатноеРасписание - ДокументСсылка.ПроектШтатногоРасписания
Процедура СоздатьВТДанныеШтатногоРасписания(МенеджерВременныхТаблиц) Экспорт
	
	Если МенеджерВременныхТаблиц.Таблицы.Найти("ВТШтатноеРасписаниеПодразделений") = Неопределено Тогда
		СоздатьВТШтатноеРасписаниеПодразделений(МенеджерВременныхТаблиц);
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;		
	Запрос.Текст = "ВЫБРАТЬ
	|	ШтатноеРасписание.Регистратор КАК ШтатноеРасписание,
	|	ШтатноеРасписание.УчебныйГод,
	|	ШтатноеРасписание.Подразделение,
	|	ШтатноеРасписание.Преподаватель,
	|	ШтатноеРасписание.Должность,
	|	ШтатноеРасписание.ВидЗанятости,
	|	ШтатноеРасписание.УченаяСтепень,
	|	ШтатноеРасписание.УченоеЗвание,
	|	ШтатноеРасписание.КоличествоСтавок,
	|	ШтатноеРасписание.КоличествоЧасов,
	|	ШтатноеРасписание.ВидЗаписи,
	|	ШтатноеРасписание.Состояние,
	|	ШтатноеРасписание.ЗамещаемыйПреподаватель,
	|	ВЫБОР
	|		КОГДА ШтатноеРасписание.ВидЗаписи.УчетДолжностей
	|		И ШтатноеРасписание.Преподаватель = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВакансия
	|ПОМЕСТИТЬ ВТДанныеШтатногоРасписания
	|ИЗ
	|	РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
	|ГДЕ
	|	ШтатноеРасписание.Регистратор В
	|		(ВЫБРАТЬ
	|			Т.ШтатноеРасписание
	|		ИЗ
	|			ВТШтатноеРасписаниеПодразделений КАК Т)";	
	
	Запрос.Выполнить();
		
КонецПроцедуры

// Формирует временную таблицу ВТШтатноеРасписаниеПодразделений с полями:
//		- Период - Дата - переданный период
//		- УчебныйГод - СправочникСсылка.УчебныеГоды - переданный учебный год
//		- Подразделение - СправочникСсылка.Подразделения - переданное подразделение
//		- ТолькоПервичный - Булево
//		- ИсключаемыйДокумент - ДокументСсылка.ПроектШтатногоРасписания
//		- ШтатноеРасписание - ДокументСсылка.ПроектШтатногоРасписания - найденный документ или пустая ссылка
// 
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - должен содержать таблицу ВТПодразделенияШтатногоРасписания 
//  	с полями: 
//  		Период - Дата, 
//  		УчебныйГод - СправочникСсылка.УчебныеГоды, 
//  		Подразделение - СправочникСсылка.Подразделения 
//			ТолькоПервичный - Булево
//			ИсключаемыйДокумент - ДокументСсылка.ПроектШтатногоРасписания
Процедура СоздатьВТШтатноеРасписаниеПодразделений(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.УчебныйГод,
	|	ВложенныйЗапрос.Подразделение,
	|	ВложенныйЗапрос.ТолькоПервичный,
	|	ВложенныйЗапрос.ИсключаемыйДокумент,
	|	ЕСТЬNULL(ШтатныеРасписанияПодразделений.ШтатноеРасписание,
	|		ЗНАЧЕНИЕ(Документ.ПроектШтатногоРасписания.ПустаяСсылка)) КАК ШтатноеРасписание
	|ПОМЕСТИТЬ ВТШтатноеРасписаниеПодразделений
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ПодразделенияШтатногоРасписания.Период,
	|		ПодразделенияШтатногоРасписания.УчебныйГод,
	|		ПодразделенияШтатногоРасписания.Подразделение,
	|		ПодразделенияШтатногоРасписания.ТолькоПервичный,
	|		ПодразделенияШтатногоРасписания.ИсключаемыйДокумент,
	|		МАКСИМУМ(ЕСТЬNULL(ШтатныеРасписанияПодразделений.Период, ДАТАВРЕМЯ(1, 1, 1))) КАК МаксПериод
	|	ИЗ
	|		ВТПодразделенияШтатногоРасписания КАК ПодразделенияШтатногоРасписания
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтатныеРасписанияПодразделений КАК ШтатныеРасписанияПодразделений
	|			ПО ШтатныеРасписанияПодразделений.УчебныйГод = ПодразделенияШтатногоРасписания.УчебныйГод
	|			И ШтатныеРасписанияПодразделений.Подразделение = ПодразделенияШтатногоРасписания.Подразделение
	|			И ШтатныеРасписанияПодразделений.Период <= ПодразделенияШтатногоРасписания.Период
	|			И ШтатныеРасписанияПодразделений.Регистратор <> ПодразделенияШтатногоРасписания.ИсключаемыйДокумент
	|			И (ШтатныеРасписанияПодразделений.Первичный
	|			ИЛИ НЕ ПодразделенияШтатногоРасписания.ТолькоПервичный)
	|	СГРУППИРОВАТЬ ПО
	|		ПодразделенияШтатногоРасписания.Период,
	|		ПодразделенияШтатногоРасписания.УчебныйГод,
	|		ПодразделенияШтатногоРасписания.Подразделение,
	|		ПодразделенияШтатногоРасписания.ТолькоПервичный,
	|		ПодразделенияШтатногоРасписания.ИсключаемыйДокумент) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтатныеРасписанияПодразделений КАК ШтатныеРасписанияПодразделений
	|		ПО ВложенныйЗапрос.УчебныйГод = ШтатныеРасписанияПодразделений.УчебныйГод
	|		И ВложенныйЗапрос.Подразделение = ШтатныеРасписанияПодразделений.Подразделение
	|		И ВложенныйЗапрос.МаксПериод = ШтатныеРасписанияПодразделений.Период";
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Формирует временную таблицу ВТНормаУчебнойНагрузки с полями:
//		- Должность - СправочникСсылка.Должности
//		- УченаяСтепень - СправочникСсылка.УченыеСтепени
//		- КоличествоЧасов - Число
//
// Параметры:
//		Дата - Дата - дата актуальности
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - должен содежрать 
//			временную таблицу ВТДолжностиИУченыеСтепени с полями:
//			* Должность - СправочникСсылка.Должности
//			* УченаяСтепень - СправочникСсылка.УченыеСтепени
Процедура СоздатьВТНормаУчебнойНагрузки(Дата, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДатаСреза", Дата);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ДолжностиИУченыеСтепени.Должность,
	|	ДолжностиИУченыеСтепени.УченаяСтепень,
	|	ЕСТЬNULL(НормаУчебнойНагрузкиСрезПоследних.КоличествоЧасов, 0) КАК КоличествоЧасов
	|ПОМЕСТИТЬ ВТНормаУчебнойНагрузки
	|ИЗ
	|	ВТДолжностиИУченыеСтепени КАК ДолжностиИУченыеСтепени
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормаУчебнойНагрузки.СрезПоследних(&ДатаСреза,) КАК
	|			НормаУчебнойНагрузкиСрезПоследних
	|		ПО ДолжностиИУченыеСтепени.Должность = НормаУчебнойНагрузкиСрезПоследних.Должность
	|		И ВЫБОР
	|			КОГДА ЕСТЬNULL(ДолжностиИУченыеСтепени.УченаяСтепень.Родитель,
	|				ЗНАЧЕНИЕ(Справочник.УченыеСтепени.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УченыеСтепени.ПустаяСсылка)
	|				ТОГДА ДолжностиИУченыеСтепени.УченаяСтепень
	|			ИНАЧЕ ДолжностиИУченыеСтепени.УченаяСтепень.Родитель
	|		КОНЕЦ = НормаУчебнойНагрузкиСрезПоследних.УченаяСтепень";	
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Возвращает норму учебной нагрузки на кафедру
//
// Параметры:
//		Дата - Дата
//		Подразделение - СправочникСсылка.Подразделения
//		УчебныйГод - СправочникСсылка.УчебныеГоды
//
// Возвращаемое значение:
//		Число - количество часов нормы учебной нагрузки на кафедру
Функция ПолучитьНормуУчебнойНагрузкиНаКафедру(Дата, Подразделение, УчебныйГод) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	НормаУчебнойНагрузкиНаКафедрыСрезПоследних.КоличествоЧасов
	|ИЗ
	|	РегистрСведений.НормаУчебнойНагрузкиНаКафедры.СрезПоследних(&Дата, УчебныйГод = &УчебныйГод
	|	И Подразделение = &Подразделение) КАК НормаУчебнойНагрузкиНаКафедрыСрезПоследних");
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("УчебныйГод", УчебныйГод);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЧасов;
	КонецЕсли;
	
	Возврат 0;
		
КонецФункции

#КонецОбласти