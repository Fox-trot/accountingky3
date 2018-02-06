﻿#Область ОбработчикиСобытийФормы
 
// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
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

// Процедура - обработчик события ПриИзменении поля ввода УстановитьНовыйСчетУчета.
//
&НаКлиенте
Процедура УстановитьНовыйСчетУчетаПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
	
	// Заполнение нового счета учета
	СчетУчетаПустаяСсылка = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПустаяСсылка");
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл 
		СтрокаТабличнойЧасти.НовыйСчетУчета = ?(Объект.УстановитьНовыйСчетУчета, СтрокаТабличнойЧасти.СчетУчета, СчетУчетаПустаяСсылка);
	КонецЦикла;	
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
		Модифицированность = Истина;

        РезультатЗаполненияПоДаннымШтрихкода = ЗаполнитьПоДаннымШтрихкода(Новый Структура("Штрихкод", ТекШтрихкод), ДополнительныеПараметры.ИмяТабличнойЧасти);
		
		Если РезультатЗаполненияПоДаннымШтрихкода.НеизвестныйШтрихкод Тогда 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Данные по штрихкоду не найдены: %1'"), ТекШтрихкод);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		ИначеЕсли РезультатЗаполненияПоДаннымШтрихкода.ШтрихкодНекорректногоТипа Тогда 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Найденная по штрихкоду %1 номенклатура: ""%2"", не подходит для этой табличной части'"),
				ТекШтрихкод, РезультатЗаполненияПоДаннымШтрихкода.СтруктураДанные.Номенклатура);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры 
// Конец ПодключаемоеОборудование

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ТоварыНовыйСчетУчета.Видимость = Объект.УстановитьНовыйСчетУчета;	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()    

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

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
	КонецЦикла;
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// ПодключаемоеОборудование
&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкоду(ДанныеШтрихкода)
	
	Номенклатура = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура", Номенклатура);
	СтруктураДанные.Вставить("ТипНоменклатурыУслуга", ?(ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура"), Номенклатура.Услуга, Ложь));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеПоШтрихкоду()

&НаКлиенте
Функция ЗаполнитьПоДаннымШтрихкода(ДанныеШтрихкода, ИмяТабличнойЧасти)
	
	НеизвестныйШтрихкод = Ложь;
	ШтрихкодНекорректногоТипа = Ложь;
	
	СтруктураДанные = ПолучитьДанныеПоШтрихкоду(ДанныеШтрихкода);
	
	Если НЕ ЗначениеЗаполнено(СтруктураДанные.Номенклатура) Тогда 
		НеизвестныйШтрихкод = Истина;
	ИначеЕсли СтруктураДанные.ТипНоменклатурыУслуга Тогда
		ШтрихкодНекорректногоТипа = Истина;
	Иначе 
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		СтрокаТабличнойЧасти.Номенклатура = СтруктураДанные.Номенклатура;
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;	
	
	Возврат Новый Структура("НеизвестныйШтрихкод, ШтрихкодНекорректногоТипа, СтруктураДанные",
		НеизвестныйШтрихкод, ШтрихкодНекорректногоТипа, СтруктураДанные);

КонецФункции // ЗаполнитьПоДаннымШтрихкода()
// Конец ПодключаемоеОборудование

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

