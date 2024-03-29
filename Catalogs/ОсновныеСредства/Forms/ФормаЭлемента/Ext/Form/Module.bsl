﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Параметры.ТекстЗаполнения) Тогда
		Объект.НаименованиеПолное = Параметры.ТекстЗаполнения;	
	КонецЕсли;
	
	ЗаполнитьОписания();
	
	// Установить видимость и доступность элементов формы.
	УстановитьВидимостьДоступностьЭлементов();

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Наименование.
//
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГруппаИмущества.
//
&НаКлиенте
Процедура ГруппаИмуществаПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КатегорияГС.
//
&НаКлиенте
Процедура КатегорияГСПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаДокументСнятияСУчетаБУНажатие(Элемент)
	Если Не ЗначениеЗаполнено(ДокументСнятоСУчетаБУ) Тогда
		Возврат;	
	КонецЕсли;  
		
	СтруктураПараметры = Новый Структура;
    СтруктураПараметры.Вставить("Ключ", ДокументСнятоСУчетаБУ);
	Если ТипЗнч(ДокументСнятоСУчетаБУ) = ТИП("ДокументСсылка.СписаниеОС") Тогда
		ОткрытьФорму("Документ.СписаниеОС.Форма.ФормаДокумента", СтруктураПараметры);
	ИначеЕсли ТипЗнч(ДокументСнятоСУчетаБУ) = ТИП("ДокументСсылка.РеализацияТоваровУслуг") Тогда
	    ОткрытьФорму("Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента", СтруктураПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаДокументПринятияКУчетуНажатие(Элемент)
	Если НЕ ЗначениеЗаполнено(ДокументПринятияКУчету) Тогда
		Возврат;	
	КонецЕсли;  
		
	ПараметрыФормы = Новый Структура;
    ПараметрыФормы.Вставить("Ключ", ДокументПринятияКУчету);
	
	ОткрытьФорму("Документ.ПринятиеКУчетуОС.Форма.ФормаДокумента", ПараметрыФормы);  		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()	
	Элементы.Организация.Видимость = ПолучитьФункциональнуюОпциюНаСервере("УчетПоНесколькимОрганизациям");
	Элементы.ГруппаСведенияОГоссобственности.Видимость = ЗначениеЗаполнено(ГруппаИмущества);
	Элементы.ИдентификационныйНомерИмущества.Видимость = ГруппаИмущества <> Справочники.ГруппыИмущества.ПустаяСсылка();		
	Элементы.Местонахождение.Видимость = ГруппаИмущества <> Справочники.ГруппыИмущества.ПустаяСсылка();
	
	Элементы.СтраницаНедвижимость.Видимость = ГруппаИмущества = Справочники.ГруппыИмущества.ГИ2
											ИЛИ ГруппаИмущества = Справочники.ГруппыИмущества.ГИ3;
	Элементы.СтраницаТранспортныйНалог.Видимость = ГруппаИмущества = Справочники.ГруппыИмущества.ГИ4;
	
КонецПроцедуры 

// Процедура заполняет доступные только для чтения реквизиты формы 
// 
&НаСервере
Процедура ЗаполнитьОписания()
	ЗаполнитьСтраницуОсновныеСведения(ЭтаФорма, Объект.Ссылка);	
	ЗаполнитьСтраницуНедвижимость(ЭтаФорма, Объект.Ссылка);
	ЗаполнитьСтраницуТранспортныйНалог(ЭтаФорма, Объект.Ссылка);
КонецПроцедуры // ЗаполнитьПоляУчета()

&НаСервереБезКонтекста
Процедура ЗаполнитьСтраницуТранспортныйНалог(ЭтаФорма, ОсновноеСредство)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СобытияОССрезПервых.ОсновноеСредство,
		|	СобытияОССрезПервых.Период КАК ДатаПриобретения
		|ПОМЕСТИТЬ ВременнаяТаблицаСобытиеПоступление
		|ИЗ
		|	РегистрСведений.СобытияОС.СрезПервых(
		|			,
		|			ОсновноеСредство = &ОсновноеСредство
		|				И (Событие = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Поступление)
		|					ИЛИ Событие = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчету))) КАК СобытияОССрезПервых
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СведенияОТранспортеСрезПоследних.ОсновноеСредство,
		|	СведенияОТранспортеСрезПоследних.ГруппаИмущества,
		|	СведенияОТранспортеСрезПоследних.ДатаВводаВЭксплуатацию,
		|	СведенияОТранспортеСрезПоследних.ВидТранспорта,
		|	СведенияОТранспортеСрезПоследних.ОбъемДвигателя,
		|	СведенияОТранспортеСрезПоследних.ГосНомер,
		|	ВременнаяТаблицаСобытиеПоступление.ДатаПриобретения
		|ИЗ
		|	РегистрСведений.СведенияОТранспорте.СрезПоследних(, ОсновноеСредство = &ОсновноеСредство) КАК СведенияОТранспортеСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСобытиеПоступление КАК ВременнаяТаблицаСобытиеПоступление
		|		ПО СведенияОТранспортеСрезПоследних.ОсновноеСредство = ВременнаяТаблицаСобытиеПоступление.ОсновноеСредство";
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ВыборкаДетальныеЗаписи)
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНедвижимость(Дата, ЭтаФорма, ОсновноеСредство)

&НаСервереБезКонтекста
Процедура ЗаполнитьСтраницуНедвижимость(ЭтаФорма, ОсновноеСредство)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СобытияОССрезПервых.ОсновноеСредство КАК ОсновноеСредство,
		|	СобытияОССрезПервых.Период КАК ДатаПриобретения
		|ПОМЕСТИТЬ ВременнаяТаблицаСобытиеПоступление
		|ИЗ
		|	РегистрСведений.СобытияОС.СрезПервых(
		|			,
		|			ОсновноеСредство = &ОсновноеСредство
		|				И (Событие = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Поступление)
		|					ИЛИ Событие = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчету))) КАК СобытияОССрезПервых
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СведенияОбИмуществеСрезПоследних.МатериалСтен КАК МатериалСтен,
		|	СведенияОбИмуществеСрезПоследних.ЖилаяПлощадь + СведенияОбИмуществеСрезПоследних.НежилаяПлощадь КАК ОсновнаяПлощадь,
		|	СведенияОбИмуществеСрезПоследних.РегиональныйКоэффициент КАК РегиональныйКоэффициент,
		|	СведенияОбИмуществеСрезПоследних.ЗональныйКоэффициент КАК ЗональныйКоэффициент,
		|	СведенияОбИмуществеСрезПоследних.ОтраслевойКоэффициент КАК ОтраслевойКоэффициент,
		|	СведенияОбИмуществеСрезПоследних.КодПользователяИмущества КАК КодПользователяИмущества,
		|	СведенияОбИмуществеСрезПоследних.ГруппаИмущества КАК ГруппаИмущества,
		|	ВременнаяТаблицаСобытиеПоступление.ДатаПриобретения КАК ДатаПриобретения
		|ИЗ
		|	РегистрСведений.СведенияОбИмуществе.СрезПоследних(, ОсновноеСредство = &ОсновноеСредство) КАК СведенияОбИмуществеСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСобытиеПоступление КАК ВременнаяТаблицаСобытиеПоступление
		|		ПО СведенияОбИмуществеСрезПоследних.ОсновноеСредство = ВременнаяТаблицаСобытиеПоступление.ОсновноеСредство";
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ВыборкаДетальныеЗаписи)
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНедвижимость(Дата, ЭтаФорма, ОсновноеСредство)

&НаСервереБезКонтекста
Процедура ЗаполнитьСтраницуОсновныеСведения(ЭтаФорма, ОсновноеСредство)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МестонахождениеОССрезПоследних.Организация КАК Организация,
		|	ПараметрыУчетаОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	ПараметрыУчетаОССрезПоследних.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ПараметрыУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
		|	ПараметрыУчетаОССрезПоследних.ГруппаНУ КАК ГруппаНУ,
		|	ПараметрыУчетаОССрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
		|	ПараметрыУчетаОССрезПоследних.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
		|	ПараметрыУчетаОССрезПоследних.СрокСлужбы КАК СрокСлужбы,
		|	ПараметрыУчетаОССрезПоследних.СпособНачисленияАмортизации КАК СпособНачисленияАмортизации,
		|	ПараметрыУчетаОССрезПоследних.СпособОтраженияРасходовПоАмортизации КАК СпособОтраженияРасходовПоАмортизации,
		|	ПараметрыУчетаОССрезПоследних.ПараметрВыработки КАК ПараметрВыработки,
		|	ПараметрыУчетаОССрезПоследних.ОбъемПродукции КАК ОбъемПродукции,
		|	ПараметрыУчетаОССрезПоследних.СпособПоступления КАК СпособПоступления,
		|	МестонахождениеОССрезПоследних.Подразделение КАК ПодразделениеБУ,
		|	МестонахождениеОССрезПоследних.МОЛ КАК МОЛБУ,
		|	ВЫБОР
		|		КОГДА СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)
		|			ТОГДА СостоянияОССрезПоследних.Период
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК ПринятоКУчетуБУ,
		|	ВЫБОР
		|		КОГДА СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.СнятоСУчета)
		|			ТОГДА СостоянияОССрезПоследних.Период
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СнятоСУчетаБУ,
		|	ВЫБОР
		|		КОГДА СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)
		|			ТОГДА СостоянияОССрезПоследних.Регистратор
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК ДокументПринятияКУчету,
		|	ВЫБОР
		|		КОГДА СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.СнятоСУчета)
		|			ТОГДА СостоянияОССрезПоследних.Регистратор
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК ДокументСнятоСУчетаБУ,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстатокКт, 0) КАК НакопленныйИзнос,
		|	ЕСТЬNULL(ПараметрыУчетаОССрезПоследних.ПервоначальнаяСтоимость, 0) - ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстатокКт, 0) КАК БалансоваяСтоимость,
		|	ПараметрыУчетаОССрезПоследних.СчетУчета.ПарныйСчет КАК СчетУчетаАмортизации,
		|	ВЫБОР
		|		КОГДА ПараметрыУчетаОССрезПоследних.СрокСлужбы = 0
		|			ТОГДА 0
		|		ИНАЧЕ 100 * 12 / ПараметрыУчетаОССрезПоследних.СрокСлужбы
		|	КОНЕЦ КАК ПроцентГодовойАмортизации
		|ИЗ
		|	РегистрСведений.ПараметрыУчетаОС.СрезПоследних(, ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыУчетаОССрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(, ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОССрезПоследних
		|		ПО ПараметрыУчетаОССрезПоследних.ОсновноеСредство = МестонахождениеОССрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОС.СрезПоследних(, ОсновноеСредство = &ОсновноеСредство) КАК СостоянияОССрезПоследних
		|		ПО ПараметрыУчетаОССрезПоследних.ОсновноеСредство = СостоянияОССрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(, , ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства), ) КАК ХозрасчетныйОстатки
		|		ПО ПараметрыУчетаОССрезПоследних.ОсновноеСредство = ХозрасчетныйОстатки.Субконто1
		|			И ПараметрыУчетаОССрезПоследних.СчетУчета.ПарныйСчет = ХозрасчетныйОстатки.Счет";
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ВыборкаДетальныеЗаписи)
	КонецЕсли;

КонецПроцедуры // ЗаполнитьСтраницуОсновныеСведения(Дата, ЭтаФорма, ОсновноеСредство)

&НаСервереБезКонтекста
Функция ПолучитьФункциональнуюОпциюНаСервере(ФО)
	Возврат ПолучитьФункциональнуюОпцию(ФО);	
КонецФункции // ПолучитьФункциональнуюОпциюНаСервере()

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




