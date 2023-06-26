#Область ОписаниеПеременных

&НаКлиенте
Перем СоответствиеВидовЗаписейИСтрокВерхнегоУровня;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Ответственный = Пользователи.ТекущийПользователь(); 
		
		Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
			ЗаполнитьРуководителяКафедры();
		КонецЕсли;
	КонецЕсли;
		
	ПодготовитьОписаниеВидовЗаписей();
	ОпределитьПредыдущуюРедакциюПроекта();	
	ПрочитатьНормуЧасовНаКафедру();
	УстановитьУсловноеОформление();	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	ЗаполнитьТаблицуНагрузки();
	РаскрытьДеревоТаблицыНагрузки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПоместитьНагрузкуВОбъект();
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда	
		ПроверитьЗаполнениеТаблицы(Отказ);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииНаСервере();
	РассчитатьИтоги();	
КонецПроцедуры

&НаКлиенте
Процедура УчебныйГодПриИзменении(Элемент)
	УчебныйГодПриИзмененииНаСервере();
	РассчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПодразделениеПриИзмененииНаСервере();
	РассчитатьИтоги();	
КонецПроцедуры

&НаКлиенте
Процедура ПервичныйПриИзменении(Элемент)
	ЗаполнитьНагрузкуИСтавкуДоИзменения();
	РассчитатьИтоги();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаНагрузки

&НаКлиенте
Процедура ТаблицаНагрузкиПередУдалением(Элемент, Отказ)
	
	Если Не ВозможноУдалитьВыделенныеСтроки() Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаНагрузкиПослеУдаления(Элемент)
	РассчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНагрузкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Отказ = Истина;

	ДанныеСтроки = Элемент.ТекущиеДанные;	
	НоваяСтрока = Неопределено;
	Если Копирование Тогда	
		НоваяСтрока = КоппироватьСтрокуТаблицыНагрузки(ДанныеСтроки);
	Иначе
		НоваяСтрока = ДобавитьСтрокуВГруппуТаблицыНагрузки(ДанныеСтроки);	
	КонецЕсли;
	
	Если Не НоваяСтрока = Неопределено Тогда
		ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
		РассчитатьИтоги();
		ПерейтиВРежимРедактированияСтроки(НоваяСтрока);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНагрузкиПреподавательПриИзменении(Элемент)
	ЗаполнитьНагрузкуИСтавкуДоИзменения();
	РассчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНагрузкиДолжностьПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.ТаблицаНагрузки.ТекущиеДанные;
	
	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
	РассчитатьИтоги();
	
	Если ЗначениеЗаполнено(СтрокаТаблицы.ТекстОшибки) Тогда
		ПроверитьЗаполнениеСтрокиТаблицы(СтрокаТаблицы);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНагрузкиУченаяСтепеньПриИзменении(Элемент)
	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
	РассчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНагрузкиКоличествоСтавокПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.ТаблицаНагрузки.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТаблицы.ТекстОшибки) Тогда
		ПроверитьЗаполнениеСтрокиТаблицы(СтрокаТаблицы);
	КонецЕсли;
	РассчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНагрузкиКоличествоЧасовПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.ТаблицаНагрузки.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТаблицы.ТекстОшибки) Тогда
		ПроверитьЗаполнениеСтрокиТаблицы(СтрокаТаблицы);
	КонецЕсли;
	РассчитатьИтоги();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ДобавитьПреподавателя(Команда)
	
	ДанныеСтроки = Элементы.ТаблицаНагрузки.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Родитель = ПолучитьТекущуюСтрокуВерхнегоУровня();
	Если Родитель = Неопределено
	Или Не Родитель.УчетДолжностей Тогда
		ПоказатьПредупреждение(, "В данную группу добавление невозможно");
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НаДату", Объект.Дата);
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("ВидЗанятости", ДанныеСтроки.ВидЗанятости);
	
	ДополнительныеПараметры = Новый Структура("Родитель", Родитель);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеСтрокиПослеВыбораПреподавателя", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаВыбораСотрудника", ПараметрыФормы, ЭтотОбъект, 
		УникальныйИдентификатор,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВакансию(Команда)
	
	ДанныеСтроки = Элементы.ТаблицаНагрузки.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Родитель = ПолучитьТекущуюСтрокуВерхнегоУровня();
	Если Родитель = Неопределено
	Или Не Родитель.УчетДолжностей Тогда
		ПоказатьПредупреждение(, "В данную группу добавление невозможно");
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ДобавитьСтрокуВГруппуТаблицыНагрузки(Родитель);

	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
	РассчитатьИтоги();
	ПерейтиВРежимРедактированияСтроки(НоваяСтрока);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСотрудниками(Команда)
	ЗаполнитьСотрудникамиНаСервере();
	ЗаполнитьТаблицуНагрузки();
	РаскрытьДеревоТаблицыНагрузки();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШтатнымРасписанием(Команда)
	ЗаполнитьШтатнымРасписаниемНаСервере();
	ЗаполнитьТаблицуНагрузки();
	РаскрытьДеревоТаблицыНагрузки();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредыдущуюРедакцию(Команда)
	ПоказатьЗначение(, ПредыдущаяРедакцияПроекта);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
	ОпределитьПредыдущуюРедакциюПроекта();
	ПрочитатьНормуЧасовНаКафедру();
КонецПроцедуры

&НаСервере
Процедура УчебныйГодПриИзмененииНаСервере()
	ЗаполнитьНагрузкуИСтавкуДоИзменения();
	ОпределитьПредыдущуюРедакциюПроекта();
	ПрочитатьНормуЧасовНаКафедру();
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()
	ЗаполнитьНагрузкуИСтавкуДоИзменения();
	ОпределитьПредыдущуюРедакциюПроекта();
	ПрочитатьНормуЧасовНаКафедру();
	ЗаполнитьРуководителяКафедры();
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеСтрокиПослеВыбораПреподавателя(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	НоваяСтрока = ДобавитьСтрокуВГруппуТаблицыНагрузки(ДополнительныеПараметры.Родитель);
	НоваяСтрока.Преподаватель = Результат.Сотрудник;
	НоваяСтрока.Должность = Результат.Должность;
	НоваяСтрока.КоличествоСтавок = Результат.КоличествоСтавок;
	НоваяСтрока.УченоеЗвание = Результат.УченоеЗвание;
	НоваяСтрока.УченаяСтепень = Результат.УченаяСтепень;
	
	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
	РассчитатьИтоги();
		
	ПерейтиКСтроке(НоваяСтрока);	
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПреподавателиВОбъекте()
	
	МассивПреподавателей = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Нагрузка, "Преподаватель", Истина);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(МассивПреподавателей, Справочники.ФизическиеЛица.ПустаяСсылка());

	Возврат МассивПреподавателей;

КонецФункции

&НаСервере
Процедура ОпределитьПредыдущуюРедакциюПроекта()
	
	ПредыдущаяРедакцияПроекта = Документы.ПроектШтатногоРасписания.НайтиДокумент(Объект.Дата, Объект.УчебныйГод, Объект.Подразделение, Объект.Ссылка);
	
	Если ЗначениеЗаполнено(ПредыдущаяРедакцияПроекта) Тогда
		Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредыдущаяРедакцияПроекта, "Дата");
		Элементы.ОткрытьПредыдущуюРедакцию.Заголовок = Формат(Дата, "ДЛФ=D;");
	КонецЕсли;
	
	Элементы.ГруппаПредыдущаяРедакция.Видимость = ЗначениеЗаполнено(ПредыдущаяРедакцияПроекта);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьОписаниеВидовЗаписей()
	
	ТаблицаВидовЗаписей = Справочники.ВидыЗаписейШтатногоРасписания.ТаблицаВидовЗаписей();
	
	Описание = Новый Соответствие();
	Массив = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ТаблицаВидовЗаписей Цикл
		Строка = Новый Структура("ВидЗанятости, УчетСтавок, УчетДолжностей");	
		ЗаполнитьЗначенияСвойств(Строка, СтрокаТаблицы);
		Описание.Вставить(СтрокаТаблицы.ВидЗаписи, Строка);
		Массив.Добавить(СтрокаТаблицы.ВидЗаписи);
	КонецЦикла;
	
	ОписаниеВидовЗаписей = Новый ФиксированноеСоответствие(Описание);
	МассивВидовЗаписей = Новый ФиксированныйМассив(Массив);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНормуЧасовНаКафедру()
	НормаЧасовНаКафедру = 0;
	
	Если ЗначениеЗаполнено(Объект.УчебныйГод)
	И ЗначениеЗаполнено(Объект.Подразделение) Тогда
		НормаЧасовНаКафедру = ШтатноеРасписание.ПолучитьНормуУчебнойНагрузкиНаКафедру(Объект.Дата, Объект.Подразделение, Объект.УчебныйГод); 	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРуководителяКафедры()
	
	Объект.РуководительКафедры = Неопределено;
	Объект.ДолжностьРуководителяКафедры = Неопределено;
	 
	СведенияРуководителя = КадроваяСтруктура.СведенияРуководителяКафедры(Объект.Дата, Объект.Подразделение);
	Если Не СведенияРуководителя = Неопределено Тогда
		Объект.РуководительКафедры = СведенияРуководителя.ФизическоеЛицо;	
		Объект.ДолжностьРуководителяКафедры = СведенияРуководителя.Должность;	
	КонецЕсли;
	
КонецПроцедуры

#Область УсловноеОформление

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	НастроитьСкрытиеПреподавателей();
	НастроитьСкрытиеВидаЗаписей();
	НастроитьОтображениеТекстаВакансияЕслиПреподавательНеУказан();
	НастроитьЗапретДоступностиККолонокамДляГруппы();
	НастроитьЗапретДоступностиИОформлениеБезУчетаДолжностей();
	НастроитьОтметкуНезаполненногоДолжности();
	НастроитьОтметкуНезаполненногоКоличестваЧасов();
	НастроитьОтметкуНезаполненногоКоличестваСтавок();
	НастроитьЗапретДоступностиИОформлениеКоличестваСтавок();
	НастроитьВидимостьТекстаОшибки();
	НастроитьОформлениеОстаткаЧасовНаКафедру();
				
КонецПроцедуры

&НаСервере
Процедура НастроитьСкрытиеПреподавателей()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиПреподаватель");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ГруппаИЛИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементОформления.Отбор, "Группа ИЛИ", 
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИЛИ, 
		"ТаблицаНагрузки.ЭтоГруппа", Истина, ВидСравненияКомпоновкиДанных.Равно);
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИЛИ, 
		"ТаблицаНагрузки.УчетДолжностей", Ложь, ВидСравненияКомпоновкиДанных.Равно);
		
КонецПроцедуры

&НаСервере
Процедура НастроитьСкрытиеВидаЗаписей()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиВидЗаписи");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.УчетДолжностей", Истина, ВидСравненияКомпоновкиДанных.Равно);
		
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеТекстаВакансияЕслиПреподавательНеУказан()

	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиПреподаватель");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", "Вакансия");
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WindowsЦвета.ТекстНедоступный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "ТаблицаНагрузки.Преподаватель",, 
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
		
КонецПроцедуры

&НаСервере
Процедура НастроитьЗапретДоступностиККолонокамДляГруппы()

	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиДолжность");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиУченаяСтепень");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиУченоеЗвание");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоЧасов");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоСтавок");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоЧасовДоИзменения");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоСтавокДоИзменения");
						
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.ЭтоГруппа", Истина, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗапретДоступностиИОформлениеБезУчетаДолжностей()

	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиДолжность");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиУченаяСтепень");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиУченоеЗвание");
						
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаНедоступноеПоле);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.УчетДолжностей", Ложь, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтметкуНезаполненногоДолжности()
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиДолжность");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "ТаблицаНагрузки.Должность",, 
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
				
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.УчетДолжностей", Истина, ВидСравненияКомпоновкиДанных.Равно);
			
КонецПроцедуры

&НаСервере
Процедура НастроитьОтметкуНезаполненногоКоличестваСтавок()
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоСтавок");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "ТаблицаНагрузки.КоличествоСтавок",, 
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
					
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.УчетСтавок", Истина, ВидСравненияКомпоновкиДанных.Равно);
				
КонецПроцедуры

&НаСервере
Процедура НастроитьОтметкуНезаполненногоКоличестваЧасов()
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоЧасов");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "ТаблицаНагрузки.КоличествоЧасов",, 
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.УчетДолжностей", Истина, ВидСравненияКомпоновкиДанных.Равно);
				
КонецПроцедуры

&НаСервере
Процедура НастроитьЗапретДоступностиИОформлениеКоличестваСтавок()
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоСтавок");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоСтавокДоИзменения");
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиКоличествоЧасовНорма");
						
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаНедоступноеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ТаблицаНагрузки.УчетСтавок", Ложь, ВидСравненияКомпоновкиДанных.Равно);
		
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьТекстаОшибки()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНагрузкиТекстОшибки");
		
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "ТаблицаНагрузки.ТекстОшибки",, ВидСравненияКомпоновкиДанных.НеЗаполнено);
		
КонецПроцедуры

&НаСервере
Процедура НастроитьОформлениеОстаткаЧасовНаКафедру()
		
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ОстатокЧасовНаКафедру");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ВажнаяНадписьШрифт);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, 
		"ОстатокЧасовНаКафедру", 0, ВидСравненияКомпоновкиДанных.Меньше);
		
КонецПроцедуры

#КонецОбласти

#Область РаботаСТаблицейНагрузки

&НаКлиенте
Процедура ЗаполнитьТаблицуНагрузки()
	
	ЭлементыДерева = ТаблицаНагрузки.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();

	ДобавитьСтрокиВерхнегоУровня();

	ПрочитатьНагрузкуИзОбъекта();
	
	ЗаполнитьДополнительныеКолонкиТаблицыНагрузки();
	РассчитатьИтоги();
			
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокиВерхнегоУровня()
	
	СоответствиеВидовЗаписейИСтрокВерхнегоУровня = Новый Соответствие();
		
	Для Каждого ВидЗаписи Из МассивВидовЗаписей Цикл
		ДобавитьСтрокуВерхнегоУровняВТаблицуНагрузки(ВидЗаписи);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНагрузкуИзОбъекта()
	
	Для Каждого СтрокаТаблицы Из Объект.Нагрузка Цикл
		
		СтрокаРодителя = СоответствиеВидовЗаписейИСтрокВерхнегоУровня[СтрокаТаблицы.ВидЗаписи];	
		Если СтрокаРодителя = Неопределено Тогда
			Продолжить;
		КонецЕсли;
			
		Если СтрокаРодителя.УчетДолжностей Тогда
			НоваяСтрока = ДобавитьСтрокуВГруппуТаблицыНагрузки(СтрокаРодителя);
			НоваяСтрока.Преподаватель = СтрокаТаблицы.Преподаватель;
			НоваяСтрока.Должность = СтрокаТаблицы.Должность;
			НоваяСтрока.УченаяСтепень = СтрокаТаблицы.УченаяСтепень;		
			НоваяСтрока.УченоеЗвание = СтрокаТаблицы.УченоеЗвание;
			НоваяСтрока.КоличествоСтавок = СтрокаТаблицы.КоличествоСтавок;
			НоваяСтрока.КоличествоЧасов = СтрокаТаблицы.КоличествоЧасов;
		Иначе
			СтрокаРодителя.КоличествоЧасов = СтрокаТаблицы.КоличествоЧасов;	
		КонецЕсли;
			
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПоместитьНагрузкуВОбъект()
	
	Объект.Нагрузка.Очистить();
	
	Для Каждого СтрокаРодитель Из ТаблицаНагрузки.ПолучитьЭлементы() Цикл	
		Если СтрокаРодитель.УчетДолжностей Тогда	
			Для Каждого СтрокаТаблицы Из СтрокаРодитель.ПолучитьЭлементы() Цикл		
				Если СтрокаТаблицы.КоличествоЧасов > 0 Тогда	
					НоваяСтрока = Объект.Нагрузка.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				КонецЕсли;
			КонецЦикла;		
		Иначе
			Если СтрокаРодитель.КоличествоЧасов > 0 Тогда
				НоваяСтрока = Объект.Нагрузка.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРодитель);	
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьДеревоТаблицыНагрузки()
	Для Каждого СтрокаТаблицы Из ТаблицаНагрузки.ПолучитьЭлементы() Цикл
		Элементы.ТаблицаНагрузки.Развернуть(СтрокаТаблицы.ПолучитьИдентификатор());
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ДобавитьСтрокуВерхнегоУровняВТаблицуНагрузки(ВидЗаписи)
	
	ОписаниеВидаЗаписи = ОписаниеВидовЗаписей[ВидЗаписи];
	
	ЭлементыДерева = ТаблицаНагрузки.ПолучитьЭлементы();
	
	СтрокаТаблицы = ЭлементыДерева.Добавить();	
	СтрокаТаблицы.ВидЗаписи = ВидЗаписи;
	СтрокаТаблицы.ВидЗанятости = ОписаниеВидаЗаписи.ВидЗанятости;
	СтрокаТаблицы.ЭтоГруппа = ОписаниеВидаЗаписи.УчетДолжностей;
	СтрокаТаблицы.УчетДолжностей = ОписаниеВидаЗаписи.УчетДолжностей;
	СтрокаТаблицы.УчетСтавок = ОписаниеВидаЗаписи.УчетСтавок;
	
	СоответствиеВидовЗаписейИСтрокВерхнегоУровня.Вставить(ВидЗаписи, СтрокаТаблицы);
		
	Возврат СтрокаТаблицы;
	
КонецФункции

&НаКлиенте
Функция ДобавитьСтрокуВГруппуТаблицыНагрузки(Родитель)
	
	Если Родитель = Неопределено
		Или Не Родитель.ЭтоГруппа Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	ЭлементыДерева = Родитель.ПолучитьЭлементы();
	
	СтрокаТаблицы = ЭлементыДерева.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Родитель,, "ЭтоГруппа");
	СтрокаТаблицы.ЭтоГруппа = Ложь;

	Возврат СтрокаТаблицы;
	
КонецФункции

&НаКлиенте
Функция ПолучитьТекущуюСтрокуВерхнегоУровня()
	
	Родитель = Элементы.ТаблицаНагрузки.ТекущиеДанные;
	Если Родитель = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозможныйРодитель = Родитель.ПолучитьРодителя();	
	Если Не ВозможныйРодитель = Неопределено Тогда
		Родитель = ВозможныйРодитель;	
	КонецЕсли;

	Возврат Родитель;

КонецФункции

&НаКлиенте
Функция КоппироватьСтрокуТаблицыНагрузки(КоппируемаяСтрока)
	
	Если Не (Не КоппируемаяСтрока.ЭтоГруппа И КоппируемаяСтрока.УчетДолжностей) Тогда
		Возврат Неопределено;
	КонецЕсли;

	НоваяСтрока = ДобавитьСтрокуВГруппуТаблицыНагрузки(КоппируемаяСтрока.ПолучитьРодителя());
	ЗаполнитьЗначенияСвойств(НоваяСтрока, КоппируемаяСтрока);
	
	Возврат НоваяСтрока;

КонецФункции

&НаКлиенте
Процедура ПерейтиВРежимРедактированияСтроки(СтрокаТаблицы)
	
	Если Не СтрокаТаблицы = Неопределено Тогда
		Элементы.ТаблицаНагрузки.ТекущийЭлемент = Элементы.ТаблицаНагрузкиДолжность;
		ПерейтиКСтроке(СтрокаТаблицы);
		Элементы.ТаблицаНагрузки.ИзменитьСтроку();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтроке(СтрокаТаблицы)
	
	Если Не СтрокаТаблицы = Неопределено Тогда
		Элементы.ТаблицаНагрузки.ТекущаяСтрока = СтрокаТаблицы.ПолучитьИдентификатор();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки)
	
	МассивСтрок = Новый Массив;
	
	Для Каждого СтрокаРодитель Из ТаблицаНагрузки.ПолучитьЭлементы() Цикл		
		Если СтрокаРодитель.ЭтоГруппа Тогда
			Для Каждого СтрокаТаблицы Из СтрокаРодитель.ПолучитьЭлементы() Цикл			
				МассивСтрок.Добавить(СтрокаТаблицы);
			КонецЦикла;		
		Иначе
			МассивСтрок.Добавить(СтрокаРодитель);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивСтрок;
	
КонецФункции

&НаКлиенте
Процедура РассчитатьИтоги()
	
	ФорматЧисла = "ЧДЦ=2; ЧН=0,00;";
	
	КоличествоСтавокИтог = 0;
	КоличествоСтавокДоИзмененияИтог = 0;
	КоличествоЧасовИтог = 0;
	КоличествоЧасовДоИзмененияИтог = 0;
	
	Для Каждого СтрокаТаблицы Из МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки) Цикл
		КоличествоСтавокИтог = КоличествоСтавокИтог + СтрокаТаблицы.КоличествоСтавок;		
		КоличествоСтавокДоИзмененияИтог = КоличествоСтавокДоИзмененияИтог + СтрокаТаблицы.КоличествоСтавокДоИзменения;		
		КоличествоЧасовИтог = КоличествоЧасовИтог + СтрокаТаблицы.КоличествоЧасов;		
		КоличествоЧасовДоИзмененияИтог = КоличествоЧасовДоИзмененияИтог + СтрокаТаблицы.КоличествоЧасовДоИзменения;		
	КонецЦикла;
		
	Элементы.ТаблицаНагрузкиКоличествоСтавок.ТекстПодвала = Формат(КоличествоСтавокИтог, ФорматЧисла); 
	Элементы.ТаблицаНагрузкиКоличествоСтавокДоИзменения.ТекстПодвала = Формат(КоличествоСтавокДоИзмененияИтог, ФорматЧисла); 
	Элементы.ТаблицаНагрузкиКоличествоЧасов.ТекстПодвала = Формат(КоличествоЧасовИтог, ФорматЧисла); 
	Элементы.ТаблицаНагрузкиКоличествоЧасовДоИзменения.ТекстПодвала = Формат(КоличествоЧасовДоИзмененияИтог, ФорматЧисла); 

	Объект.КоличествоЧасовИтого = КоличествоЧасовИтог;
	ОстатокЧасовНаКафедру = НормаЧасовНаКафедру - Объект.КоличествоЧасовИтого;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьНагрузкуИСтавкуДоИзменения(ТаблицаНагрузки)	
	Для Каждого СтрокаТаблицы Из МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки) Цикл	
		СтрокаТаблицы.КоличествоСтавокДоИзменения = 0;	
		СтрокаТаблицы.КоличествоЧасовДоИзменения = 0;	
	КонецЦикла;			
КонецПроцедуры

&НаКлиенте
Функция ВозможноУдалитьВыделенныеСтроки()

	Для Каждого ИдентификаторСтроки Из Элементы.ТаблицаНагрузки.ВыделенныеСтроки Цикл
		ДанныеСтроки = ТаблицаНагрузки.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ДанныеСтроки.ЭтоГруппа Или Не ДанныеСтроки.УчетДолжностей Тогда
			Возврат Ложь;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#Область ЗаполнениеТаблицыИзВнешнихИсточников

&НаСервере
Процедура ЗаполнитьДополнительныеКолонкиТаблицыНагрузки()
	
	ЗаполнитьНагрузкуИСтавкуДоИзменения();	
	ЗаполнитьНормуУчебнойНагрузки();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНагрузкуИСтавкуДоИзменения()
	
	ОчиститьНагрузкуИСтавкуДоИзменения(ТаблицаНагрузки);
	
	Если Не ЗначениеЗаполнено(Объект.Подразделение)
		Или Не ЗначениеЗаполнено(Объект.УчебныйГод) Тогда
		Возврат;	
	КонецЕсли;
	
	МассивПреподаватели = ПреподавателиВОбъекте();
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();

	ПараметрыПолучения = ШтатноеРасписание.ПараметрыПолученияШтатногоРасписания();
	ПараметрыПолучения.Дата = Объект.Дата;
	ПараметрыПолучения.УчебныйГод = Объект.УчебныйГод;
	ПараметрыПолучения.Подразделение = Объект.Подразделение;
	ПараметрыПолучения.ИсключаемыйДокумент = Объект.Ссылка;
	
	ШтатноеРасписание.СоздатьВТДанныеШтатногоРасписанияПоПараметрам(ПараметрыПолучения, МенеджерВременныхТаблиц);
	
	ПараметрыПолучения = Кадры.ПараметрыПолученияКадовыхДанныхСотрудников();
	ПараметрыПолучения.Дата = Объект.Дата;
	ПараметрыПолучения.Подразделение = Объект.Подразделение;
	ПараметрыПолучения.ТолькоРаботающие = Истина;
	ПараметрыПолучения.Сотрудники = МассивПреподаватели;
	
	Кадры.СоздатьВТКадровыеДанныеСотрудниковПоПараметрам(ПараметрыПолучения, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЕСТЬNULL(ДанныеШтатногоРасписания.ВидЗаписи, ЗНАЧЕНИЕ(Справочник.ВидыЗаписейШтатногоРасписания.ПустаяСсылка)) КАК ВидЗаписи,
	|	ЕСТЬNULL(ДанныеШтатногоРасписания.Преподаватель, КадровыеДанныеСотрудников.Сотрудник) КАК Преподаватель,
	|	ЕСТЬNULL(ДанныеШтатногоРасписания.Должность, КадровыеДанныеСотрудников.Должность) КАК Должность,
	|	ЕСТЬNULL(ДанныеШтатногоРасписания.ВидЗанятости, КадровыеДанныеСотрудников.ВидЗанятости) КАК ВидЗанятости,
	|	ЕСТЬNULL(ДанныеШтатногоРасписания.КоличествоСтавок, КадровыеДанныеСотрудников.КоличествоСтавок) КАК КоличествоСтавок,
	|	ЕСТЬNULL(ДанныеШтатногоРасписания.КоличествоЧасов, 0) КАК КоличествоЧасов
	|ИЗ
	|	ВТДанныеШтатногоРасписания КАК ДанныеШтатногоРасписания
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеШтатногоРасписания.Преподаватель = КадровыеДанныеСотрудников.Сотрудник
	|		И ДанныеШтатногоРасписания.Подразделение = КадровыеДанныеСотрудников.Подразделение
	|		И ДанныеШтатногоРасписания.Должность = КадровыеДанныеСотрудников.Должность
	|		И ДанныеШтатногоРасписания.ВидЗанятости = КадровыеДанныеСотрудников.ВидЗанятости";
	
	ДанныеШтатногоРасписания = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицы Из МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки) Цикл	
									
		ПараметрыОтбра = Новый Структура;
		ПараметрыОтбра.Вставить("Преподаватель", СтрокаТаблицы.Преподаватель);
		ПараметрыОтбра.Вставить("Должность", СтрокаТаблицы.Должность);
		ПараметрыОтбра.Вставить("ВидЗанятости", СтрокаТаблицы.ВидЗанятости);
					
		НайденнаяСтрокаШР = Неопределено;
		НайденнаяСтрокаКД = Неопределено;
		НайденныеСтроки = ДанныеШтатногоРасписания.НайтиСтроки(ПараметрыОтбра);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока.ВидЗаписи = СтрокаТаблицы.ВидЗаписи Тогда
				НайденнаяСтрокаШР = НайденнаяСтрока;	
			ИначеЕсли Не ЗначениеЗаполнено(НайденнаяСтрока.ВидЗаписи) Тогда
				НайденнаяСтрокаКД = НайденнаяСтрока;	
			КонецЕсли;
		КонецЦикла;
	
		Если Не НайденнаяСтрокаШР = Неопределено Тогда
			СтрокаТаблицы.КоличествоСтавокДоИзменения = НайденнаяСтрокаШР.КоличествоСтавок;	
			СтрокаТаблицы.КоличествоЧасовДоИзменения = НайденнаяСтрокаШР.КоличествоЧасов;		
		ИначеЕсли Не НайденнаяСтрокаКД = Неопределено Тогда
			СтрокаТаблицы.КоличествоСтавокДоИзменения = НайденнаяСтрокаКД.КоличествоСтавок;			
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудникамиНаСервере()
	
	ПараметрыПолучения = Кадры.ПараметрыПолученияКадовыхДанныхСотрудников();
	ПараметрыПолучения.Дата = Объект.Дата;
	ПараметрыПолучения.Подразделение = Объект.Подразделение;
	ПараметрыПолучения.ТолькоРаботающие = Истина;
	
	КадрвыеДанныеСотрудников = Кадры.КадрвыеДанныеСотрудников(ПараметрыПолучения);
	
	Объект.Нагрузка.Очистить();
	
	Для Каждого СтрокаТаблицы Из КадрвыеДанныеСотрудников Цикл
		
		ВидЗаписи = ШтатноеРасписаниеКлиентСервер.ОпределитьВидЗаписиПоВидуЗанятости(СтрокаТаблицы.ВидЗанятости);
		Если Не ЗначениеЗаполнено(ВидЗаписи) Тогда
			Продолжить;	
		КонецЕсли;
	
		НоваяСтрока = Объект.Нагрузка.Добавить();
		НоваяСтрока.ВидЗаписи = ВидЗаписи;
		НоваяСтрока.Преподаватель = СтрокаТаблицы.Сотрудник;	
		НоваяСтрока.Должность = СтрокаТаблицы.Должность;
		НоваяСтрока.ВидЗанятости = СтрокаТаблицы.ВидЗанятости;
		НоваяСтрока.УченаяСтепень = СтрокаТаблицы.УченаяСтепень;
		НоваяСтрока.УченоеЗвание = СтрокаТаблицы.УченоеЗвание;
		НоваяСтрока.КоличествоСтавок = СтрокаТаблицы.КоличествоСтавок;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШтатнымРасписаниемНаСервере()
		
	ПараметрыПолучения = ШтатноеРасписание.ПараметрыПолученияШтатногоРасписания();
	ПараметрыПолучения.Дата = Объект.Дата;
	ПараметрыПолучения.УчебныйГод = Объект.УчебныйГод;
	ПараметрыПолучения.Подразделение = Объект.Подразделение;
	ПараметрыПолучения.ИсключаемыйДокумент = Объект.Ссылка;
	
	ДанныеШтатногоРасписания = ШтатноеРасписание.ДанныеШтатногоРасписания(ПараметрыПолучения);
	
	Объект.Нагрузка.Очистить();
	
	Для Каждого СтрокаТаблицы Из ДанныеШтатногоРасписания Цикл
		НоваяСтрока = Объект.Нагрузка.Добавить();
		НоваяСтрока.ВидЗаписи = СтрокаТаблицы.ВидЗаписи;
		НоваяСтрока.Преподаватель = СтрокаТаблицы.Преподаватель;	
		НоваяСтрока.Должность = СтрокаТаблицы.Должность;
		НоваяСтрока.ВидЗанятости = СтрокаТаблицы.ВидЗанятости;
		НоваяСтрока.УченаяСтепень = СтрокаТаблицы.УченаяСтепень;
		НоваяСтрока.УченоеЗвание = СтрокаТаблицы.УченоеЗвание;
		НоваяСтрока.КоличествоСтавок = СтрокаТаблицы.КоличествоСтавок;
		НоваяСтрока.КоличествоЧасов = СтрокаТаблицы.КоличествоЧасов;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНормуУчебнойНагрузки()

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Должность,
	|	Т.УченаяСтепень
	|ПОМЕСТИТЬ ВТДолжностиИУченыеСтепени
	|ИЗ
	|	&Таблица КАК Т";
	
	Запрос.УстановитьПараметр("Таблица", ТаблицаДляПолученияНормыУчебнойНагрузки());
	
	Запрос.Выполнить();
	
	ШтатноеРасписание.СоздатьВТНормаУчебнойНагрузки(Объект.Дата, Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	НормаУчебнойНагрузки.Должность,
	|	НормаУчебнойНагрузки.УченаяСтепень,
	|	НормаУчебнойНагрузки.КоличествоЧасов
	|ИЗ
	|	ВТНормаУчебнойНагрузки КАК НормаУчебнойНагрузки";
	НормаУчебнойНагрузки = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицы Из МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки) Цикл	
		Если Не СтрокаТаблицы.УчетДолжностей Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Должность", СтрокаТаблицы.Должность);		
		ПараметрыПоиска.Вставить("УченаяСтепень", СтрокаТаблицы.УченаяСтепень);	
			
		НайденныеСтроки = НормаУчебнойНагрузки.НайтиСтроки(ПараметрыПоиска);
		Если НайденныеСтроки.Количество() Тогда
			СтрокаТаблицы.КоличествоЧасовНорма = НайденныеСтроки[0].КоличествоЧасов;	
		Иначе
			СтрокаТаблицы.КоличествоЧасовНорма = 0;
		КонецЕсли;		
	КонецЦикла;		
	
КонецПроцедуры

&НаСервере
Функция ТаблицаДляПолученияНормыУчебнойНагрузки()
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("Должность", Новый ОписаниеТипов("СправочникСсылка.Должности"));
	ТаблицаЗначений.Колонки.Добавить("УченаяСтепень", Новый ОписаниеТипов("СправочникСсылка.УченыеСтепени"));
		
	Для Каждого СтрокаТаблицы Из МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки) Цикл			
		Если Не СтрокаТаблицы.УчетДолжностей Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;		
	
	ТаблицаЗначений.Свернуть("Должность, УченаяСтепень");
	
	Возврат ТаблицаЗначений;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПроверкиЗаполнения

&НаКлиенте
Процедура ПроверитьЗаполнениеТаблицы(Отказ)

	Для Каждого СтрокаТаблицы Из МассивСтрокБезГруппИзТаблицыНагрузки(ТаблицаНагрузки) Цикл
		ПроверитьЗаполнениеСтрокиТаблицы(СтрокаТаблицы, Отказ);
	КонецЦикла;
		
	Если Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Возникли ошибки при проверке заполнения",, "ТаблицаНагрузки",, Отказ);	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеСтрокиТаблицы(СтрокаТаблицы, Отказ = Ложь)

	МассивОшибок = Новый Массив;
	
	ПроверитьЗаполненностьДолжностиПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок);
	ПроверитьЗаполненностьКоличестваСтавокПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок);
	ПроверитьЗаполненностьКоличестваЧасовПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок);
	ПроверитьУчебнуюНагрузкуНаПревышениеНормыПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок);
	
	Если МассивОшибок.Количество() Тогда
		Отказ = Истина;		
	КонецЕсли;
	
	СтрокаТаблицы.ТекстОшибки = СтрСоединить(МассивОшибок, Символы.ПС);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполненностьДолжностиПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок)
	
	ТекстОшибки = "Не заполнена должность";
	
	Если СтрокаТаблицы.УчетДолжностей И Не ЗначениеЗаполнено(СтрокаТаблицы.Должность) Тогда
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполненностьКоличестваСтавокПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок)
	
	ТекстОшибки = "Не заполнена новая ставка";
	
	Если СтрокаТаблицы.УчетСтавок И Не ЗначениеЗаполнено(СтрокаТаблицы.КоличествоСтавок) Тогда
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполненностьКоличестваЧасовПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок)
	
	ТекстОшибки = "Не заполнена новая учебная нагрузка";
	
	Если СтрокаТаблицы.УчетДолжностей И Не ЗначениеЗаполнено(СтрокаТаблицы.КоличествоЧасов) Тогда
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьУчебнуюНагрузкуНаПревышениеНормыПоСтрокеТаблицы(СтрокаТаблицы, МассивОшибок)
	
	ТекстОшибки = "Превышение нормы (%1 ч. для %2 ставки) учебной нагрузки на %3 ч.";
	
	КоличествоЧасовНорма = СтрокаТаблицы.КоличествоЧасовНорма * СтрокаТаблицы.КоличествоСтавок;
	РазницаЧасов = КоличествоЧасовНорма - СтрокаТаблицы.КоличествоЧасов;
	
	Если СтрокаТаблицы.УчетДолжностей
	И Не СтрокаТаблицы.ВидЗанятости = ПредопределенноеЗначение("Перечисление.ВидыЗанятости.Почасовое")
	И РазницаЧасов < 0 Тогда			
		ТекстОшибки = СтрШаблон(ТекстОшибки, 
			Формат(КоличествоЧасовНорма, "ЧГ="),
			Формат(СтрокаТаблицы.КоличествоСтавок, "ЧГ="),
			Формат(-РазницаЧасов, "ЧГ="));
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти