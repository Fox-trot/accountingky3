﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьНачальныеСвойстваСубконтоТаблицы();
	КонецЕсли;	

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);		
	
	УстановитьУсловноеОформление();

	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСервере(Элементы, "Товары");
	// Конец КопированиеСтрокТабличныхЧастей
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = ПодключаемоеОборудованиеБППовтИсп.ИспользоватьПодключаемоеОборудование();
	Элементы.ЗапасыЗагрузитьДанныеИзТСД.Видимость = ИспользоватьПодключаемоеОборудование;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище);
		
		УстановитьНачальныеСвойстваСубконтоТаблицы();
	
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Товары");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			// Преобразуем предварительно к ожидаемому формату.
			Если Параметр[1] = Неопределено Тогда
				ТекШтрихкод = Параметр[0]; // Достаем штрихкод из основных данных
			Иначе
				ТекШтрихкод = Параметр[1][1]; // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			ПоискПоШтрихкодуЗавершение(ТекШтрихкод, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Товары"));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьНачальныеСвойстваСубконтоТаблицы();

	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	УстановитьНачальныеСвойстваСубконтоТаблицы();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	КонтрольВеденияУчета.ПослеЗаписиНаСервере(ТекущийОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(
		Объект.Товары,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

// Процедура - обработчик события ПередНачаломИзменения таблицы Товары.
//
&НаКлиенте
Процедура ТоварыПередНачаломИзменения(Элемент, Отказ)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоСтроки(
		ЭтотОбъект, ТекущиеДанные, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти, "Товары");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СчетЗатрат.
//
&НаКлиенте
Процедура ТоварыСчетЗатратПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект, ТекущиеДанные, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСубконто1.
//
&НаКлиенте
Процедура ТоварыСубконто1ПриИзменении(Элемент)
	ПриИзмененииСубконто(1);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода ТоварыСубконто1.
//
&НаКлиенте
Процедура ТоварыСубконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСубконто2.
//
&НаКлиенте
Процедура ТоварыСубконто2ПриИзменении(Элемент)
	ПриИзмененииСубконто(2);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода ТоварыСубконто2.
//
&НаКлиенте
Процедура ТоварыСубконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСубконто3.
//
&НаКлиенте
Процедура ТоварыСубконто3ПриИзменении(Элемент)
	ПриИзмененииСубконто(3);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода ТоварыСубконто3.
//
&НаКлиенте
Процедура ТоварыСубконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события действия команды Подбор в табличную часть Товары.
// Открывает форму подбора.
//
&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "Списание");
КонецПроцедуры

// ПодключаемоеОборудование
&НаКлиенте
Процедура ПоискПоШтрихкодуТовары(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Товары")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекШтрихкод = ?(Результат = Неопределено, ДополнительныеПараметры.ТекШтрихкод, Результат);
    
	Если НЕ ПустаяСтрока(ТекШтрихкод) Тогда
        ПолученыШтрихкоды(Новый Структура("Штрихкод, Количество", ТекШтрихкод, 1), ДополнительныеПараметры.ИмяТабличнойЧасти);
	КонецЕсли;	

КонецПроцедуры 

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	ПодключаемоеОборудованиеБПКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, "Товары");
КонецПроцедуры // ЗагрузитьДанныеИзТСД()
// Конец ПодключаемоеОборудование

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		Отказ = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Склад"". Заполнение закладки ""Товары"" отменено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Склад",,Отказ);
		
		Если Отказ Тогда
			Возврат;	
		КонецЕсли;
	КонецЕсли;	
	
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьТовары", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Закладка ""Товары"" будет перезаполнена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ЗаполнитьТоварыПоОстаткам();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьТовары(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
        ЗаполнитьТоварыПоОстаткам();
    КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Таблица Товары.
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТоварыСубконто1");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Субконто1Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТоварыСубконто2");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Субконто2Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТоварыСубконто3");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Субконто3Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - обработчик подбора товаров.
//
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура, СчетУчета", СтрокаЗагрузки.Номенклатура, СтрокаЗагрузки.СчетУчета));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		
		СтруктураДанные = Новый Структура();
		СтруктураДанные.Вставить("Организация", Объект.Организация);
		СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
		
		СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

		// Заполнение по данным номенклатуры
		СтрокаТабличнойЧасти.СчетЗатрат = СтруктураДанные.СчетРасхода;
	КонецЦикла;
		
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

&НаКлиенте
Процедура ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти, ИмяТабличнойЧасти)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

	// Заполнение по данным номенклатуры
	СтрокаТабличнойЧасти.СчетЗатрат = СтруктураДанные.СчетРасхода;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект, СтрокаТабличнойЧасти, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры	

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	// Счета учета
	СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(СтруктураДанные.Организация, СтруктураДанные.Номенклатура);
	СтруктураДанные.Вставить("СчетРасхода", СчетаУчетаНоменклатуры.СчетРасхода);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// ПодключаемоеОборудование

// Процедура - Получены штрихкоды
//
// Параметры:
//  ДанныеШтрихкодов	 - Структура/Массив - В зависимости от точки вызова передается структура (обработка сканера) или массив (обработка ТСД)
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части для загрузки
//
&НаКлиенте
Процедура ПолученыШтрихкоды(ДанныеШтрихкодов, ИмяТабличнойЧасти) Экспорт
	
	Модифицированность = Истина;
	
	НеДобавленныеШтрихкоды = ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрихкодов, ИмяТабличнойЧасти);
	
	// Неизвестные штрихкоды.
	Если НеДобавленныеШтрихкоды.НеизвестныеШтрихкоды.Количество() > 0 Тогда
		Для Каждого СтруктураДанные Из НеДобавленныеШтрихкоды.НеизвестныеШтрихкоды Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Данные по штрихкоду не найдены: %1'"), СтруктураДанные.Штрихкод);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	// Штрихкоды некорректного типа.
	ИначеЕсли НеДобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа.Количество() > 0 Тогда 
		Для Каждого СтруктураДанные Из НеДобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Найденная по штрихкоду %1 номенклатура: ""%2"", не подходит для этой табличной части'"),
				СтруктураДанные.ТекШтрихкод, СтруктураДанные.Номенклатура);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры // ПолученыШтрихкоды()

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкоду(ТекШтрихкод)
	
	Номенклатура = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьНоменклатуруПоШтрихкоду(ТекШтрихкод);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура", Номенклатура);
	СтруктураДанные.Вставить("ТипНоменклатурыУслуга", ?(ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура"), Номенклатура.Услуга, Ложь));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеПоШтрихкоду()

// Функция - Заполнить по данным штрихкодов
//
// Параметры:
//  ДанныеШтрихкодов		 - 	 - Структура/Массив	 - В зависимости от точки вызова передается структура (обработка сканера) или массив (обработка ТСД)
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части для загрузки
// 
// Возвращаемое значение:
//  Структура - Массивы неизвестных штрих кодов
//
&НаКлиенте
Функция ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрихкодов, ИмяТабличнойЧасти) 
	
	НеизвестныеШтрихкоды = Новый Массив;
	ШтрихкодыНекорректногоТипа = Новый Массив;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	Для каждого ТекШтрихкод Из МассивШтрихкодов Цикл
		СтруктураДанные = ПолучитьДанныеПоШтрихкоду(ТекШтрихкод);
		
		Если НЕ ЗначениеЗаполнено(СтруктураДанные.Номенклатура) Тогда 
			НеизвестныеШтрихкоды.Добавить(ТекШтрихкод);
		ИначеЕсли СтруктураДанные.ТипНоменклатурыУслуга Тогда
			ШтрихкодыНекорректногоТипа.Добавить(Новый Структура("ТекШтрихкод, Номенклатура", ТекШтрихкод, СтруктураДанные.Номенклатура));
		Иначе 
			СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
			СтрокаТабличнойЧасти.Номенклатура = СтруктураДанные.Номенклатура;
			СтрокаТабличнойЧасти.Количество = ТекШтрихкод.Количество;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Новый Структура("НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа",
		НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа);

КонецФункции // ЗаполнитьПоДаннымШтрихкодов()
// Конец ПодключаемоеОборудование

&НаСервере
Процедура ЗаполнитьТоварыПоОстаткам()

	Объект.Товары.Очистить();
	
	ВидыСубконто = Новый Массив;
	Видысубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Видысубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Счет КАК СчетУчета,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК Количество,
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Период, , &ВидыСубконто, Субконто2 = &Склад) КАК ХозрасчетныйОстатки
		|ГДЕ
		|	ХозрасчетныйОстатки.Субконто1 <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)";
	Запрос.УстановитьПараметр("Период", 		ДатаДокумента + 1);
	Запрос.УстановитьПараметр("ВидыСубконто", 	ВидыСубконто);
	Запрос.УстановитьПараметр("Склад", 			Объект.Склад);
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();			
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка); 
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРаботаССубконто

&НаСервере
Процедура УстановитьНачальныеСвойстваСубконтоТаблицы()
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.Товары,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"ТоварыСубконто", "Субконто", "СчетЗатрат");
	
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	Результат.СкрыватьСубконто = Ложь;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	СтрокаТаблицы = Элементы.Товары.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		СтрокаТаблицы,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Элементы.Товары.ТекущиеДанные, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

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

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура ТоварыКопироватьСтроки(Команда)
	
	КопироватьСтроки("Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВставитьСтроки(Команда)
	
	ВставитьСтроки("Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСтроки(ИмяТЧ)
	
	Если КопированиеТабличнойЧастиКлиент.МожноКопироватьСтроки(Объект[ИмяТЧ], Элементы[ИмяТЧ].ТекущиеДанные) Тогда
		КоличествоСкопированных = 0;
		КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных);
		КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(ИмяТЧ)
	
	КоличествоСкопированных = 0;
	КоличествоВставленных = 0;
	ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных);
	КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных)
	
	КопированиеТабличнойЧастиСервер.Копировать(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки, КоличествоСкопированных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных)
	
	КопированиеТабличнойЧастиСервер.Вставить(Объект, ИмяТЧ, Элементы, КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииКомиссия

// Процедура - обработчик события команды ПодборФизическихЛиц.
// Открывает форму выбора.
//
&НаКлиенте
Процедура ПодборФизическихЛиц(Команда)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элементы.Комиссия);

КонецПроцедуры

// Процедура - обработчик события ПередУдалением таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПередУдалением(Элемент, Отказ)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.Председатель Тогда
		ИндексУдаляемойСтроки = Объект.Комиссия.Индекс(ТекущаяСтрокаТЧ);
		КоличествоСтрок = Объект.Комиссия.Количество() - 1;

		Если КоличествоСтрок > 0 Тогда
			Если ИндексУдаляемойСтроки <= КоличествоСтрок - 1 Тогда
				ИндексНовогоПредседателя = ИндексУдаляемойСтроки + 1;
			Иначе
				ИндексНовогоПредседателя = КоличествоСтрок - 1;
			КонецЕсли;
			Объект.Комиссия[ИндексНовогоПредседателя].Председатель = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриНачалеРедактирования таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
		ТекущаяСтрокаТЧ.ФизЛицо = Неопределено;
		ТекущаяСтрокаТЧ.Председатель = Ложь;
	Иначе // Создание заново
		Если Объект.Комиссия.Количество() = 1 Тогда
			Объект.Комиссия[0].Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Строки = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

	Если Строки.Количество() > 0 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже подобрано.'"), ВыбранноеЗначение);
		ПоказатьПредупреждение(, ТекстСообщения, 60);
	Иначе
		НоваяСтрока = Объект.Комиссия.Добавить();
		НоваяСтрока.ФизЛицо = ВыбранноеЗначение;
		Если Объект.Комиссия.Количество() = 1 Тогда
			НоваяСтрока.Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Председатель.
//
&НаКлиенте
Процедура КомиссияПредседательПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если НЕ ТекущаяСтрокаТЧ.Председатель Тогда
		// Снимать флажок нельзя
		ТекущаяСтрокаТЧ.Председатель = Истина;
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТЧ Из Объект.Комиссия Цикл
		Если СтрокаТЧ.НомерСтроки <> ТекущаяСтрокаТЧ.НомерСтроки Тогда
			СтрокаТЧ.Председатель = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоПриИзменении(Элемент)

	Если Объект.Комиссия.Количество() = 1 Тогда
		Объект.Комиссия[0].Председатель = Истина;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.ФизЛицо <> ВыбранноеЗначение Тогда

		СтрокиТабличнойЧасти = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже включено в состав комиссии.'"), ВыбранноеЗначение);
			ПоказатьПредупреждение(, ТекстСообщения, 60);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти