/////////////////////////////////////////////////////////////////////////////////
// ПРОВЕДЕНИЕ, СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ                                   //
/////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

///////////////////////////////////////////////////////////////////////////////////
// Процедуры для подготовки и записи движений документа.
// 
// Процедура вызывается из подписки на событие.
// Процедура формирует таблицу проводок. Если реквизиты операции есть в ДополнительныхСвойствах объекта,
// то для вычисления таблицы проводок используются переданные реквизиты, иначе берутся записанные в регистр значения.
// Процедура устанавливает только таблицу проводок. Остальные реквизиты остаются без изменения, как пришли.
//
Процедура ПередЗаписьюОбъекта(ТекущийОбъект, Отказ, РежимЗаписи, РежимПроведения) Экспорт

	УстановитьРежимПроведения(ТекущийОбъект, РежимЗаписи, РежимПроведения);

	ТекущийОбъект.ДополнительныеСвойства.Вставить("РежимЗаписи",     РежимЗаписи);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РежимПроведения", РежимПроведения);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЭтоНовый",        ТекущийОбъект.ЭтоНовый());

КонецПроцедуры

// Процедура инициализирует общие структуры, используемые при проведении документов.
// Вызывается из модуля документов при проведении.
//
Процедура ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, ДополнительныеСвойства, РежимПроведения = Неопределено) Экспорт

	// В структуре "ДополнительныеСвойства" создаются свойства с ключами "ТаблицыДляДвижений", "ДляПроведения".

	// "ТаблицыДляДвижений" - структура, которая будет содержать таблицы значений с данными для выполнения движений.
	ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);

	// "ДляПроведения" - структура, содержащая свойства и реквизиты документа, необходимые для проведения.
	ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	
	// Структура, содержащая ключ с именем "МенеджерВременныхТаблиц", в значении которого хранится менеджер временных таблиц.
	// Содержит для каждой временной таблицы ключ (имя временной таблицы) и значение (признак наличия записей во временной таблице).
	ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	ДополнительныеСвойства.ДляПроведения.Вставить("РежимПроведения",           РежимПроведения);
	ДополнительныеСвойства.ДляПроведения.Вставить("МетаданныеДокумента",       ДокументСсылка.Метаданные());
	ДополнительныеСвойства.ДляПроведения.Вставить("Ссылка",                    ДокументСсылка);

КонецПроцедуры

Процедура ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства) Экспорт

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();

КонецПроцедуры

// Функция формирует массив имен регистров, по которым документ имеет движения.
// Вызывается при подготовке записей к регистрации движений.
//
Функция ПолучитьМассивИспользуемыхРегистров(Регистратор, Движения, МассивИсключаемыхРегистров = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);

	Результат = Новый Массив;
	МаксимумТаблицВЗапросе = 256;

	СчетчикТаблиц   = 0;
	СчетчикДвижений = 0;

	ВсегоДвижений = Движения.Количество();
	ТекстЗапроса  = "";
	Для Каждого Движение Из Движения Цикл

		СчетчикДвижений = СчетчикДвижений + 1;

		ПропуститьРегистр = МассивИсключаемыхРегистров <> Неопределено
							И МассивИсключаемыхРегистров.Найти(Движение.Имя) <> Неопределено;

		Если Не ПропуститьРегистр Тогда

			Если СчетчикТаблиц > 0 Тогда

				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|";

			КонецЕсли;

			СчетчикТаблиц = СчетчикТаблиц + 1;

			ТекстЗапроса = ТекстЗапроса + 
			"
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|""" + Движение.Имя + """ КАК ИмяРегистра
			|
			|ИЗ " + Движение.ПолноеИмя() + "
			|
			|ГДЕ Регистратор = &Регистратор
			|";

		КонецЕсли;

		Если СчетчикТаблиц = МаксимумТаблицВЗапросе Или СчетчикДвижений = ВсегоДвижений Тогда

			Запрос.Текст  = ТекстЗапроса;
			ТекстЗапроса  = "";
			СчетчикТаблиц = 0;
			Если Запрос.Текст = "" Тогда
				//В запросе нет текста, все регистры пропущены
				Продолжить;
			КонецЕсли;
			
			Если Результат.Количество() = 0 Тогда

				//@skip-check query-in-loop
				Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");

			Иначе

				//@skip-check query-in-loop
				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					Результат.Добавить(Выборка.ИмяРегистра);
				КонецЦикла;

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Процедура выполняет подготовку наборов записей документа к записи движений.
// 1. Очищает наборы записей от "старых записей" (ситуация возможна только в толстом клиенте)
// 2. Взводит флаг записи у наборов, по которым документ имеет движения
// Вызывается из модуля документов при проведении.
// 
// В ДополнительныхСвойствах объекта может быть задан ключ МассивИменРегистров, 
// содержащий массив имен регистров для изменения.
// В этом случае будут изменены только перечисленные регистры.
//
Процедура ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект) Экспорт

	МассивИменРегистров = Неопределено;
	Если Объект.ДополнительныеСвойства.Свойство("МассивИменРегистров") Тогда
		МассивИменРегистров = Объект.ДополнительныеСвойства.МассивИменРегистров;
	КонецЕсли;
	
	// Регистры, движения по которым формируются не из модуля менеджера документа
	НеОчищаемыеРегистры = Новый Соответствие;
	
	Если МассивИменРегистров = Неопределено Тогда
		
		Для Каждого НаборЗаписей Из Объект.Движения Цикл
			
			// Регистры, движения по которым формируются не из модуля менеджера документа.
			Если НеОчищаемыеРегистры.Получить(ТипЗнч(НаборЗаписей)) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если НаборЗаписей.Количество() > 0 Тогда
				НаборЗаписей.Очистить();
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для каждого ТекДвижение Из МассивИменРегистров Цикл
		
			Если Объект.Движения.Найти(ТекДвижение)<>Неопределено Тогда
				
				НаборЗаписей = Объект.Движения[ТекДвижение];	
				Если НаборЗаписей.Количество() > 0 Тогда
					НаборЗаписей.Очистить();
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЕсли;
	
	Если Не Объект.ДополнительныеСвойства.ЭтоНовый Тогда
		
		Если МассивИменРегистров = Неопределено Тогда
			// Регистры, движения по которым формируются не из модуля менеджера документа.
			ИсключаемыеРегистры = Новый Массив;
			Если Объект.ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
				// При проведении заполняем вручную, при отмене проведения очищаем стандартным образом.
				//ИсключаемыеРегистры.Добавить();
			КонецЕсли;
			
			МассивИменРегистров = ПолучитьМассивИспользуемыхРегистров(Объект.Ссылка,
					Объект.ДополнительныеСвойства.ДляПроведения.МетаданныеДокумента.Движения,
					ИсключаемыеРегистры);
			
		КонецЕсли;
		
		Для Каждого ИмяРегистра Из МассивИменРегистров Цикл
			Объект.Движения[ИмяРегистра].Записывать = Истина;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

// Процедура записывает движения документа. Дополнительно происходит копирование параметров
// в модули наборов записей для выполнения регистрации изменений в движениях.
// Процедура вызывается из модуля документов при проведении.
//
Процедура ЗаписатьНаборыЗаписей(Объект) Экспорт
	Перем РегистрыДляКонтроля;

	// Регистры, для которых будут рассчитаны таблицы изменений движений.
	Если Объект.ДополнительныеСвойства.ДляПроведения.Свойство("РегистрыДляКонтроля", РегистрыДляКонтроля) Тогда
		Для Каждого НаборЗаписей Из РегистрыДляКонтроля Цикл
			Если НаборЗаписей.Записывать Тогда

				// Установка флага регистрации изменений в наборе записей.
				НаборЗаписей.ДополнительныеСвойства.Вставить("РассчитыватьИзменения", Истина);
				НаборЗаписей.ДополнительныеСвойства.Вставить("ЭтоНовый", Объект.ДополнительныеСвойства.ЭтоНовый);

				// Структура для передачи данных в модули наборов записей.
				НаборЗаписей.ДополнительныеСвойства.Вставить("ДляПроведения", 
						Новый Структура("СтруктураВременныеТаблицы", Объект.ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы));

			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Объект.Движения.Записать();

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// Процедуры формирования движений

Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	// Инициализация дополнительных свойств для проведения документа
	ИнициализироватьДополнительныеСвойстваДляПроведения(Объект.Ссылка, Объект.ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	ИмяДокумента = Объект.Метаданные().Имя;
	Документы[ИмяДокумента].ИнициализироватьДанныеДокумента(Объект.Ссылка, Объект.ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект);
	
	// Отражение наборов записей
	ОтразитьДвиженияПоРегистрам(Объект);
	
	// Запись движений
	ЗаписатьНаборыЗаписей(Объект);
	
	// Очистка временных таблиц
	ОчиститьДополнительныеСвойстваДляПроведения(Объект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	Для Каждого НаборЗаписей Из Объект.Движения Цикл
		НаборЗаписей.Записывать = Истина;
	КонецЦикла;
	
	Объект.Движения.Записать();
	
КонецПроцедуры

Процедура ОтразитьДвиженияПоРегистрам(Объект) Экспорт

	Для Каждого КлючТаблицы Из Объект.ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		
		ТаблицаДвижений = КлючТаблицы.Значение;
		
		Если ТаблицаДвижений.Количество() > 0 Тогда
			ДвиженияДокумента = Объект.Движения.Найти(КлючТаблицы.Ключ);
			Если ДвиженияДокумента <> Неопределено Тогда  
				ДвиженияДокумента.Записывать = Истина;
				ДвиженияДокумента.Загрузить(ТаблицаДвижений);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтразитьДвиженияПоРегистру(ДополнительныеСвойства, Движения, Отказ, ИмяТаблицы) Экспорт

	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений[ИмяТаблицы];
	
	Если Отказ Или ТаблицаДвижений.Количество() = 0 Тогда	
		Возврат;		
	КонецЕсли;
	
	ДвиженияДокумента = Движения[ИмяТаблицы];
	ДвиженияДокумента.Записывать = Истина;
	ДвиженияДокумента.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

// Формирует и записывает движения документа по списку регистров с блокировкой регистров
// описание параметров см. ОтразитьДвиженияДокументаПоРегистрам
//
Процедура ОтразитьДвиженияДокументаПоРегистрамОтложенно(ДокументСсылка, Регистры) Экспорт
	
	Попытка
		
		НачатьТранзакцию();
		
		// Устанавливаем блокировку на все регистры
		Блокировка = Новый БлокировкаДанных;
		Для Каждого Регистр Из Регистры Цикл
			ЭлементБлокировки = Блокировка.Добавить(Регистр + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ДокументСсылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;			
		КонецЦикла;
		Блокировка.Заблокировать();
		
		ОтразитьДвиженияДокументаПоРегистрам(ДокументСсылка, Регистры);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Формирует и записывает движения документа по списку регистров
//
// Параметры:
//  ДокументСсылка	 - ДокументСсылка	- Ссылка на документ
//  Регистры		 - Массив			- Массив имен регистров, по которым нужно отразить движения.
//										  (допускается содержание регистра, для которого документ не является регистратором)
//
Процедура ОтразитьДвиженияДокументаПоРегистрам(ДокументСсылка, Регистры) Экспорт
	
	ТаблицыДляДвижений = Новый Структура;
	ДополнительныеСвойства = Новый Структура("ТаблицыДляДвижений", ТаблицыДляДвижений);
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументСсылка);
	
	Менеджер.ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства);
	
	Для Каждого ИмяРегистра Из Регистры Цикл
		ОтразитьДвиженияПоРегиструЗаписать(ДокументСсылка, ТаблицыДляДвижений, ИмяРегистра); 
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтразитьДвиженияПоРегиструЗаписать(ДокументСсылка, ТаблицыДляДвижений, ИмяТаблицы)

	ЧастиИмени	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяТаблицы, ".");
	ТипРегистра	= ЧастиИмени[0];
	ИмяРегистра	= ЧастиИмени[1];
	 
	Если ТипРегистра = "РегистрСведений" Тогда
		Регистр = РегистрыСведений[ИмяРегистра];
	ИначеЕсли ТипРегистра = "РегистрНакопления" Тогда
	    Регистр = РегистрыНакопления[ИмяРегистра];
	Иначе // другие регистры не нужны
		Возврат;
	КонецЕсли;	
	
	ДвиженияДокумента = Регистр.СоздатьНаборЗаписей();
	ОтборРегистратор = ДвиженияДокумента.Отбор.Найти("Регистратор");
	Если ОтборРегистратор <> Неопределено
		И ОтборРегистратор.ТипЗначения.СодержитТип(ТипЗнч(ДокументСсылка)) Тогда
		ОтборРегистратор.Установить(ДокументСсылка);
		ТаблицаДвижений = Неопределено;		
		Если Не ТаблицыДляДвижений.Свойство(ИмяРегистра, ТаблицаДвижений) Тогда
			ТаблицаДвижений = Новый ТаблицаЗначений;
		КонецЕсли;
		ДвиженияДокумента.Загрузить(ТаблицаДвижений);
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(ДвиженияДокумента);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры

Процедура УстановитьРежимПроведения(ДокументОбъект, РежимЗаписи, РежимПроведения) Экспорт

	Если ДокументОбъект.Проведен И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
