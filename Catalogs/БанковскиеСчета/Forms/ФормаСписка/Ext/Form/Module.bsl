﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	СписокБанкСчетовПоУмолчанию = ПолучитьБанкСчетаПоУмолчанию();
	Если СписокБанкСчетовПоУмолчанию.Количество() > 0 Тогда
		УстановитьОформлениеБанкСчетовПоУмолчанию(СписокБанкСчетовПоУмолчанию);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.БанковскиеСчета);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Устанавливает текущий элемент банковским счетом по умолчанию для владельца
//
Процедура УстановитьКакБанкСчетПоУмолчанию(Команда)
	
	СписокБанкСчетовПоУмолчанию = Новый СписокЗначений;
	
	ТекущаяСтрокаСписка = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрокаСписка = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран банковский счет, который необходимо установить как банковский счет по умолчанию'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	НовыйБанкСчетПоУмолчанию	= ТекущаяСтрокаСписка.Ссылка;
	ВладелецСсылка				= ТекущаяСтрокаСписка.Владелец;
	
	Для каждого ЭлементУсловногоОформления Из Список.УсловноеОформление.Элементы Цикл
		Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный" И
			ЭлементУсловногоОформления.Представление = "Банковский счет по умолчанию" Тогда
			
			ЭлементОтбора				= ЭлементУсловногоОформления.Отбор.Элементы[0];
			СписокБанкСчетовПоУмолчанию	= ЭлементОтбора.ПравоеЗначение;
			
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ СписокБанкСчетовПоУмолчанию.НайтиПоЗначению(НовыйБанкСчетПоУмолчанию) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьКарточкуОбъектаВладелецаИПоменятьОформлениеСписка(ВладелецСсылка, НовыйБанкСчетПоУмолчанию, СписокБанкСчетовПоУмолчанию);
	
	Оповестить("ИзмененОсновнойБанковскийСчет");
	
КонецПроцедуры // УстановитьКакБанкСчетПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
// Функция получает и возвращает выборку банк. счетов по умолчанию 
// 
// МассивБанковскихСчетов - массив банковских счетов по умолчанию.
//
Функция ПолучитьБанкСчетаПоУмолчанию(МассивВладельцев = Неопределено)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.ОсновнойБанковскийСчет КАК БанковскийСчет
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ОсновнойБанковскийСчет = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяССылка)
		|	И &УсловиеОтбораПоКонтрагентам
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Организации.ОсновнойБанковскийСчет
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	НЕ Организации.ОсновнойБанковскийСчет = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяССылка)
		|	И &УсловиеОтбораПоОрганизациям
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ФизическиеЛица.ОсновнойБанковскийСчет
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	НЕ ФизическиеЛица.ОсновнойБанковскийСчет = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяССылка)
		|	И &УсловиеОтбораПоФизлицу";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
		"&УсловиеОтбораПоКонтрагентам",
		?(ТипЗнч(МассивВладельцев) = Тип("Массив"), "Контрагенты.Ссылка В (&МассивВладельцев)", "Истина"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
		"&УсловиеОтбораПоОрганизациям",
		?(ТипЗнч(МассивВладельцев) = Тип("Массив"), "Организации.Ссылка В (&МассивВладельцев)", "Истина"));
				
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
		"&УсловиеОтбораПоФизлицу",
		?(ТипЗнч(МассивВладельцев) = Тип("Массив"), "ФизическиеЛица.Ссылка В (&МассивВладельцев)", "Истина"));		
		
	РезультатЗапроса			= Запрос.Выполнить().Выгрузить();
	
	СписокБанкСчетовПоУмолчанию	= Новый СписокЗначений;
	СписокБанкСчетовПоУмолчанию.ЗагрузитьЗначения(РезультатЗапроса.ВыгрузитьКолонку("БанковскийСчет"));
	
	Возврат СписокБанкСчетовПоУмолчанию;
	
КонецФункции //ПолучитьБанкСчетаПоУмолчанию()

&НаСервере
// Процедура выделяет в списке банк. счета по умолчанию
//
Процедура УстановитьОформлениеБанкСчетовПоУмолчанию(СписокБанкСчетовПоУмолчанию)
	
	Для каждого ЭлементУсловногоОформления Из Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы Цикл
		Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный" Тогда
			Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Удалить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыУсловногоОформленияСписка	= Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы;
	ЭлементУсловногоОформления			= ЭлементыУсловногоОформленияСписка.Добавить();
	
	ЭлементОтбора 						= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЭлементОтбора.ЛевоеЗначение 		= Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения 			= ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение 		= СписокБанкСчетовПоУмолчанию;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина,));
	
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
	ЭлементУсловногоОформления.Представление = "Банковский счет по умолчанию";  
	
КонецПроцедуры //УстановитьОформлениеБанкСчетовПоУмолчанию()

&НаСервере
// Процедура - записывает в карточку владельца новое значение
// и обновляет визуальное представление банк. счета по умолчанию в форме списке
//
Процедура ИзменитьКарточкуОбъектаВладелецаИПоменятьОформлениеСписка(ВладелецСсылка, НовыйБанкСчетПоУмолчанию, СписокБанкСчетовПоУмолчанию)
	
	ОбъектВладелец 							= ВладелецСсылка.ПолучитьОбъект();
	СтарыйБанкСчетПоУмолчанию				= ОбъектВладелец.ОсновнойБанковскийСчет;
	ОбъектВладелец.ОсновнойБанковскийСчет	= НовыйБанкСчетПоУмолчанию;
	
	БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(ОбъектВладелец);
	
	ЭлементСпискаЗначений = СписокБанкСчетовПоУмолчанию.НайтиПоЗначению(СтарыйБанкСчетПоУмолчанию);
	
	Если НЕ ЭлементСпискаЗначений = Неопределено Тогда
		СписокБанкСчетовПоУмолчанию.Удалить(ЭлементСпискаЗначений);
	КонецЕсли;
	
	СписокБанкСчетовПоУмолчанию.Добавить(НовыйБанкСчетПоУмолчанию);
	
	УстановитьОформлениеБанкСчетовПоУмолчанию(СписокБанкСчетовПоУмолчанию);
	
КонецПроцедуры //ИзменитьКарточкуВладельцаИПоменятьОформлениеСписка()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
