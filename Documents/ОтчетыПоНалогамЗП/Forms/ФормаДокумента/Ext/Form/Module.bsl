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
	
	УстановитьПараметрыДинамическихСписков();
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(ДатаДокумента, Объект.Организация);

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
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
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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
	
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(ДатаДокумента, Объект.Организация);

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаСдачиОтчета.
//
&НаКлиенте
Процедура ДатаСдачиОтчетаПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(ДатаДокумента, Объект.Организация);
	
	УстановитьПараметрыДинамическихСписков();
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

&НаКлиенте
Процедура ВидСубъектаПриИзменении(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЕжемесячныеПлатежиВСФ

&НаКлиенте
Процедура ЕжемесячныеПлатежиВСФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	НаименованиеДинамическогоСписка = "ЕжемесячныеПлатежиВСФ";
	ДокументМенеджер = ДанныеДинамическогоСписка(ВыбраннаяСтрока, НаименованиеДинамическогоСписка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ОткрытьФорму(ДокументМенеджер + ".ФормаОбъекта", ПараметрыФормы, Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПодоходныйНалог(Команда)
	
	Если Объект.ПодоходныйНалог.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьПодоходныйНалог", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьПодоходныйНалогНаСервере();		
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьПодоходныйНалогПриложениеНаСервере();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСоцфонд(Команда)
	
	Если Объект.СведенияОЗанятостиИЗаработнойПлате.Количество() > 0 Или  Объект.ФондОплатыТрудаПоКатегориям.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличныеЧастиСоцфонд", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьСоцфондНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ПодоходныйНалог.Количество() > 0 Или Объект.СведенияОЗанятостиИЗаработнойПлате.Количество() > 0 Или  Объект.ФондОплатыТрудаПоКатегориям.Количество() > 0  Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьВсеТабличныеЧасти", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьПодоходныйНалогНаСервере();
		ЗаполнитьСоцфондНаСервере();
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьПодоходныйНалогПриложениеНаСервере();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЕжемесячныйСоцфонд_Excel(Команда)
	
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для формирования отчета в электронной форме
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект, Новый Структура("НаправлениеВыгрузки", "ЕжемесячныйСоцфонд_Excel"));
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьВыгрузку("ЕжемесячныйСоцфонд_Excel");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаВ_xml(Команда)
	
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для формирования отчета в электронной форме
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект, Новый Структура("НаправлениеВыгрузки", "ВыгрузкаВ_xml"));
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьВыгрузку("ВыгрузкаВ_xml");
	КонецЕсли;		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьПодоходныйНалог(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПодоходныйНалогНаСервере();
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьПодоходныйНалогПриложениеНаСервере();
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличныеЧастиСоцфонд(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьСоцфондНаСервере();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьВсеТабличныеЧасти(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПодоходныйНалогНаСервере();
		ЗаполнитьСоцфондНаСервере();
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьПодоходныйНалогПриложениеНаСервере();
		КонецЕсли;

	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Если КонецМесяца(Объект.Дата) <> КонецКвартала(Объект.Дата) Тогда 
		Элементы.СтраницаПодоходныйНалогПриложение.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры 

// Процедура для установления параметров динамических списков.
//
&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()

	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(Объект.Дата, Объект.Организация);
	МассивСчетов = Новый Массив();
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовПФФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовМСФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовФОТФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовГНПФР);
	
	Если Объект.ДатаСдачиОтчета = '00010101' Тогда
		КонецПериода = КонецМесяца(Объект.Дата);
	Иначе
		КонецПериода = Объект.ДатаСдачиОтчета;
	КонецЕсли;
	
	Если НЕ Объект.Дата = '00010101' Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ОтчетыПоНалогамЗП.Ссылка,
			|	ВЫБОР
			|		КОГДА ОтчетыПоНалогамЗП.ДатаСдачиОтчета = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА ОтчетыПоНалогамЗП.Дата
			|		ИНАЧЕ ОтчетыПоНалогамЗП.ДатаСдачиОтчета
			|	КОНЕЦ КАК ДатаНачалаЕжемесячныхПлатежей
			|ИЗ
			|	Документ.ОтчетыПоНалогамЗП КАК ОтчетыПоНалогамЗП
			|ГДЕ
			|	ОтчетыПоНалогамЗП.Дата <= &ДатаНачалаОтчета
			|	И НЕ ОтчетыПоНалогамЗП.ПометкаУдаления
			|
			|УПОРЯДОЧИТЬ ПО
			|	ОтчетыПоНалогамЗП.Дата УБЫВ";
		Запрос.УстановитьПараметр("ДатаНачалаОтчета", НачалоМесяца(Объект.Дата));
		
		Результат = Запрос.Выполнить().Выбрать();
		Результат.Следующий();

		ЕжемесячныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Результат.ДатаНачалаЕжемесячныхПлатежей);
	Иначе
		ЕжемесячныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоМесяца(Объект.Дата));	
	КонецЕсли;
	
	ЕжемесячныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецПериода);
	ЕжемесячныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("СписокСчетов", МассивСчетов);
	ЕжемесячныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);
	
КонецПроцедуры

// Функция считывает данные динамического списка.
//
// Параметры:
//  	ВыбраннаяСтрока - Число - номер выбираемой строки в динамичеком списке.
//  	НаименованиеДинамическогоСписка - Строка - название динамического списка.
//
// Возвращаемое значение:
//		ДокументМенеджер - Строка, название документа, для его открытия.
//
&НаСервере
Функция ДанныеДинамическогоСписка(ВыбраннаяСтрока, НаименованиеДинамическогоСписка)
	
	Схема = Элементы.ЕжемесячныеПлатежиВСФ.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.ЕжемесячныеПлатежиВСФ.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
			
	ВыбраннаяСтрока = ВыбраннаяСтрока - 1;	
	Если ТипЗнч(Результат[ВыбраннаяСтрока].Ссылка) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") Тогда
		ДокументМенеджер = "Документ.ПлатежноеПоручениеИсходящее";
	Иначе
		ДокументМенеджер = "Документ.РасходныйКассовыйОрдер";
	КонецЕсли;
	
	Возврат ДокументМенеджер;
		
КонецФункции

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

&НаСервере
Процедура ЗаполнитьПодоходныйНалогНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьПодоходныйНалог(ДанныеУчетнойПолитики);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодоходныйНалогПриложениеНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьПодоходныйНалогПриложение(ДанныеУчетнойПолитики);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоцфондНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьСоцфонд();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаСервере
Функция ТребуетсяНастройкаАвторизацияИнтернетПоддержки()
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Возврат Не (ДанныеАутентификации <> Неопределено
			И ЗначениеЗаполнено(ДанныеАутентификации.Логин)
			И ЗначениеЗаполнено(ДанныеАутентификации.Пароль));
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПриПодключенииИнтернетПоддержки(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект, ДополнительныеПараметры);
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт
	Если Не (ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)
		И ЗначениеЗаполнено(Результат.Пароль)) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.НаправлениеВыгрузки = "ВыгрузкаВ_xml" Тогда
		ПродолжитьСохранение();	
	Иначе
		ПродолжитьВыгрузку("ЕжемесячныйСоцфонд_Excel");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДиалогОткрытияФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ВидДиалога = "ЕжемесячныйСоцфонд_Excel" Тогда
		Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
			ФормированиеФайла(ВыбранныеФайлы[0], ДополнительныеПараметры);
		КонецЕсли;
	
	Иначе	      		
		Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
			Попытка
				Ошибки = Неопределено;
				СтруктураДанных = ФормированиеФайлаXML(ДополнительныеПараметры, Ошибки);
			Исключение
				ТекстСообщения = НСтр("ru='Не удалось завершить формирование файла.
					|Техническая информация об ошибке: %1'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));	
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат;
			КонецПопытки;
			
			Если НЕ Ошибки = Неопределено Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);	
				Возврат;
			КонецЕсли;		
			
			// Формирование имени файла.
			КаталогФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВыбранныеФайлы[0]);
			ИмяФайла = СтруктураДанных.ИмяФайла;
			ПолноеИмяФайла = КаталогФайла + ИмяФайла;
			
			// Сохранение файла.
			Двоичное = ПолучитьИзВременногоХранилища(СтруктураДанных.АдресВременногоХранилища);
			Двоичное.Записать(ПолноеИмяФайла);	
			
			ТекстСообщения = НСтр("ru='Файл успешно сохранен.
				|Имя файла: %1'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ПолноеИмяФайла);	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСохранение()
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите путь для сохранения файла'");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ВидДиалога", "ПродолжитьСохранение");
	
	Оповещение = Новый ОписаниеОповещения("ДиалогОткрытияФайлаЗавершение", ЭтотОбъект, СтруктураПараметров);
	ДиалогОткрытияФайла.Показать(Оповещение);

КонецПроцедуры // ПродолжитьСохранение()

&НаКлиенте
Процедура ПродолжитьВыгрузку(НаправлениеВыгрузки)
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда  
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Выполнение действия возможно только после записи данных.
			|Данные будут записаны.'");
		Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыПослеПодтвержденияЗаписи", ЭтотОбъект, Новый Структура("ВидДиалога", НаправлениеВыгрузки));
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;		
	
	ПродолжитьВыгрузкуЗавершение(НаправлениеВыгрузки);

КонецПроцедуры // ПродолжитьВыгрузку()

// Ветка процедуры, возникающая после диалога подтверждения записи.
&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыПослеПодтвержденияЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		Записать();
		Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьВыгрузкуЗавершение(ДополнительныеПараметры.ВидДиалога)
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыгрузкуЗавершение(НаправлениеВыгрузки)
 
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВидДиалога", НаправлениеВыгрузки);
	
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры 

&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите путь для сохранения файла'");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ДиалогОткрытияФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогОткрытияФайла.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормированиеФайла(КаталогФайлаВыгрузки, ДополнительныеПараметры)
	
	КаталогФайлаВыгрузки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогФайлаВыгрузки);
	
	// Открытие приложения Excel
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		ИнформацияОбОшибке = Неопределено;
	Исключение
		ВызватьИсключение НСтр("ru = 'Не удалось подключить COM-объект Excel.
			|Вероятные причины:
			| - На сервере не установлен Microsoft Office;
			| - У пользователя недостаточно прав на создание COM-объектов;
			| - Включен контроль учетных записей Windows;
			| - Операционная система не из семейства Windows.
			|
			|Техническая информация:
			|'") + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Excel.Visible = 0;
	Excel.DisplayAlerts = 0;
	Excel.DefaultSaveFormat = 51;
	
	Расширение = "xlsx";
	ТипФайла = ТипФайлаТабличногоДокумента.XLSX;
	
	// Проверка версии
	ВерсияExcel = Лев(Excel.Version, Найти(Excel.Version,".") -1);
	Если ВерсияExcel < "16" Тогда
		ТекстСообщения = НСтр("ru = 'Используется устаревшая версия Excel. Возможны ошибки.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		// для сохранения в старом формате
		Excel.DefaultSaveFormat = 56;
		Расширение = "xls";  
		ТипФайла = ТипФайлаТабличногоДокумента.XLS;
	Конецесли;

	ПолноеИмяФайла = КаталогФайлаВыгрузки + "Ежемесячный соцфонд" + Формат(Объект.Дата,"ДФ=yyyyMMdd") + "." + Расширение;

	ТабличныйДокументПриложение = ОтчетЕжемесячныйСоцфонд();
	ТабличныйДокументПриложение.Записать(ПолноеИмяФайла, ТипФайла);
	
	// Закрытие приложения
	Excel.Quit();	
	Excel = Неопределено;
	
	ТекстОповещения = НСтр("ru = 'Файл сформирован'");
	ТекстПояснения = ПолноеИмяФайла;
	ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения, БиблиотекаКартинок.Информация32);
КонецПроцедуры // ФормированиеФайла()

// Функция - Отчет НДСОсновная форма
// 
// Возвращаемое значение:
//  ТабличныйДокумент - 
//
&НаСервере
Функция ОтчетЕжемесячныйСоцфонд()
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = Документы.ОтчетыПоНалогамЗП.ПолучитьМакет("ПФ_MXL_СФЕжемесячный_Excel");
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
	ДанныеОрганизации = ПолучитьДанныеОрганизации(Объект.Организация);
	ДанныеПечати = Новый Структура; 
	ДанныеПечати.Вставить("Плательщик",  Объект.Организация.НаименованиеПолное);
	ДанныеПечати.Вставить("ИНН", 		 Объект.Организация.ИНН);
	ДанныеПечати.Вставить("РегНомер", 	 Объект.Организация.РегНомерСоцФонда);
	ДанныеПечати.Вставить("ОКПО", 		 Объект.Организация.КодПоОКПО);
	ДанныеПечати.Вставить("ОтделениеСФ", Объект.Контрагент);
	ДанныеПечати.Вставить("Дата", 		 Формат(Объект.Дата,"ДФ='ММММ гггг'"));
	ДанныеПечати.Вставить("ДатаДок", 	 Формат(ДобавитьМесяц(Объект.Дата, 1),"ДФ='ММММ гггг'"));														   
	ДанныеПечати.Вставить("Адрес", 		 ДанныеОрганизации.АдресОрганизации);
	ДанныеПечати.Вставить("Телефон", 	 ДанныеОрганизации.Телефон);
	
	ДанныеПечати.Вставить("НаименованиеБанка", ДанныеОрганизации.НаименованиеБанка);
	ДанныеПечати.Вставить("БанковскийСчет", ДанныеОрганизации.БанковскийСчет);
	ДанныеПечати.Вставить("ВидДеятельности", ДанныеОрганизации.ВидДеятельности);
	
	ДанныеПечати.Вставить("СуммаКтПФ_МС_ФОТФ", Объект.ОбязательстваПоСтраховымВзносам);
	ДанныеПечати.Вставить("СуммаКтГНПФ", Объект.ОбязательстваПоПенсионномуФонду);
	ДанныеПечати.Вставить("СуммаДтПФ_МС_ФОТФ", Объект.ПереплатаПоСтраховымВзносам);
	ДанныеПечати.Вставить("СуммаДтГНПФ", Объект.ПереплатаПоПенсионномуФонду);
	ДанныеПечати.Вставить("ИтогоОбязательства", Объект.ОбязательстваПоСтраховымВзносам + Объект.ОбязательстваПоПенсионномуФонду);
	ДанныеПечати.Вставить("ИтогоПереплата", Объект.ПереплатаПоСтраховымВзносам + Объект.ПереплатаПоПенсионномуФонду);
	
	Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Объект.Организация, ДатаДокумента);
	ДанныеПечати.Вставить("Руководитель", Руководители.Руководитель);
	ДанныеПечати.Вставить("ГлавныйБухгалтер", Руководители.ГлавныйБухгалтер);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ДанныеПечатиИтоги = Новый Структура; 
	ДанныеПечатиИтоги.Вставить("ФОТ",0);
	ДанныеПечатиИтоги.Вставить("ДопФОТ",0);
	ДанныеПечатиИтоги.Вставить("СтраховыеВзносы",0);
	ДанныеПечатиИтоги.Вставить("ГНПФР",0);
	ДанныеПечатиИтоги.Вставить("Численность",0);
	ДанныеПечатиИтоги.Вставить("ФОТБольше40Процентов",0);
	ДанныеПечатиИтоги.Вставить("ФОТМеньше40Процентов",0);
	ДанныеПечатиИтоги.Вставить("Всего",0);

	Для Каждого СтрокаТабличнойЧасти Из Объект.СведенияОЗанятостиИЗаработнойПлате Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("ДеталиСведенияОЗП");
		ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
		ОбластьМакета.Параметры.ИНН = СтрокаТабличнойЧасти.ФизЛицо.ИНН;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ДанныеПечатиИтоги.ФОТ 				= ДанныеПечатиИтоги.ФОТ 			+ СтрокаТабличнойЧасти.ФондОплатыТруда;
		ДанныеПечатиИтоги.ДопФОТ 			= ДанныеПечатиИтоги.ДопФОТ 			+ СтрокаТабличнойЧасти.ДополнительныйФондОплатыТруда;
		ДанныеПечатиИтоги.СтраховыеВзносы 	= ДанныеПечатиИтоги.СтраховыеВзносы + СтрокаТабличнойЧасти.НачисленыеСтраховыеВзносы;
		ДанныеПечатиИтоги.ГНПФР 			= ДанныеПечатиИтоги.ГНПФР 			+ СтрокаТабличнойЧасти.НачсиленыеВзносыПоНПФ;
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ИтогоСведенияОЗП");
	ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаФОТПоКатегориям");
	ТабличныйДокумент.Вывести(ОбластьМакета);
		
	// Обнуляется значение "ДопФОТ" для нового заполнения.
	ДанныеПечатиИтоги.ДопФОТ = 0;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.ФондОплатыТрудаПоКатегориям Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("ДеталиФОТПоКатегориям");
		ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ДанныеПечатиИтоги.Численность 		 	= ДанныеПечатиИтоги.Численность 		 + СтрокаТабличнойЧасти.Численость;
		ДанныеПечатиИтоги.ФОТБольше40Процентов 	= ДанныеПечатиИтоги.ФОТБольше40Процентов + СтрокаТабличнойЧасти.ФОТБолее;
		ДанныеПечатиИтоги.ФОТМеньше40Процентов	= ДанныеПечатиИтоги.ФОТМеньше40Процентов + СтрокаТабличнойЧасти.ФОТМенее;
		ДанныеПечатиИтоги.ДопФОТ 				= ДанныеПечатиИтоги.ДопФОТ 				 + СтрокаТабличнойЧасти.ДопФОТ;
		ДанныеПечатиИтоги.Всего 				= ДанныеПечатиИтоги.Всего 				 + СтрокаТабличнойЧасти.Итого;
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ИтогоФОТПоКатегориям");
	ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Коды");	
	ТабличныйДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Обязательства");	
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);		
	ТабличныйДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");	
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);		
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабличныйДокумент;	
КонецФункции // ОтчетНДСОсновнаяФорма()

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Органинизации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизации(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);
	
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон = СведенияОбОрганизации.Тел;
	НаименованиеГКЭД = СведенияОбОрганизации.НаименованиеГКЭД;
	НаименованиеПолное = СведенияОбОрганизации.НаименованиеПолное;
	РегНомерСоцФонда = СведенияОбОрганизации.РегНомерСоцФонда;
	ИНН = СведенияОбОрганизации.ИНН;
	ОКПО = СведенияОбОрганизации.ОКПО;
	АдрЮР = СведенияОбОрганизации.АдрЮР;
	
	НаименованиеБанка = Организация.ОсновнойБанковскийСчет.Банк.Наименование;
	БанковскийСчет = Организация.ОсновнойБанковскийСчет.НомерСчета;
	
	Структура = Новый Структура();
	Структура.Вставить("АдресОрганизации", АдресОрганизации);
	Структура.Вставить("Телефон", Телефон);
	Структура.Вставить("НаименованиеБанка", НаименованиеБанка);
	Структура.Вставить("БанковскийСчет", БанковскийСчет);
	Структура.Вставить("ВидДеятельности", НаименованиеГКЭД);
	Структура.Вставить("НаименованиеПолное", НаименованиеПолное);
	Структура.Вставить("РегНомерСоцФонда", РегНомерСоцФонда);
	Структура.Вставить("ИНН", ИНН);
	Структура.Вставить("ОКПО", ОКПО);
	Структура.Вставить("АдрЮР", АдрЮР);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

&НаСервере
Функция ФормированиеФайлаXML(ДополнительныеПараметры, Ошибки)
		                           
	ШаблонИмениФайла = СтрШаблон("Monthly social fund %1", Формат(ДатаДокумента, "ДЛФ=D"));
	ИмяФайла = ШаблонИмениФайла + ".xml";
	
	ОбъектXDTO = СоздатьОбъектXDTO("PaySheet");
	
	// Создание PayerInfo.
	PayerInfo = СоздатьОбъектXDTO("PayerInfo");
	
	СведенийОбОрганизации = ПолучитьДанныеОрганизации(Объект.Организация);
	
	ArrearsOfWages = 0;
	AmountOfContributions = 0;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СведенияОЗанятостиИЗаработнойПлате Цикл
		
		ArrearsOfWages = ArrearsOfWages + 
			?(Объект.Округление, Окр(СтрокаТабличнойЧасти.НачисленыеСтраховыеВзносы), СтрокаТабличнойЧасти.НачисленыеСтраховыеВзносы)
			+ СтрокаТабличнойЧасти.НачсиленыеВзносыПоНПФ;
			
		AmountOfContributions = AmountOfContributions +	СтрокаТабличнойЧасти.ФондОплатыТруда;
	КонецЦикла;	
		
	PayerInfo.Year 					= Год(ДатаДокумента);
	PayerInfo.TaxPayer 				= СведенийОбОрганизации.НаименованиеПолное;
	PayerInfo.TariffType 			= "1";
	PayerInfo.PIN 					= СведенийОбОрганизации.ИНН;
	PayerInfo.OKPO 					= СведенийОбОрганизации.ОКПО;
	PayerInfo.Month 				= "--" + СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Строка(Месяц(ДатаДокумента)), 2) + "--";
	PayerInfo.ArrearsOfWages 		= Формат(ArrearsOfWages, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");
	PayerInfo.AmountOfContributions = Формат(AmountOfContributions, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");

	ОбъектXDTO.PayerInfo.Добавить(PayerInfo);
	
	ОбъектXDTO.SalaryInfoCollection.Добавить(SalaryInfoCollection());	
	
	ОбъектXDTO.PayerBalanceOfArrearsCollection.Добавить(PayerBalanceOfArrearsCollection());	
	

	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ЗаписьXML = Новый ЗаписьXML;
	ПараметрыЗаписиXML = Новый ПараметрыЗаписиXML("UTF-8", "1.0", Ложь);	
	ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, ПараметрыЗаписиXML);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);
	ЗаписьXML.Закрыть();
	
	Двоичное = Новый ДвоичныеДанные(ИмяВременногоФайла);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Двоичное, ЭтаФорма.УникальныйИдентификатор);
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ИмяФайла", ИмяФайла);
	СтруктураДанных.Вставить("АдресВременногоХранилища", АдресВременногоХранилища);
	
	Возврат СтруктураДанных;
КонецФункции // ФормированиеФайла()

&НаСервере
Функция СоздатьОбъектXDTO(ТипОбъекта)
	УстановитьПривилегированныйРежим(Истина);
	Возврат ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.akforta.com/PaySheet", ТипОбъекта));
КонецФункции // СоздатьОбъектXDTO()

&НаСервере
Функция SalaryInfoCollection()
	
	ОбъектXDTO = СоздатьОбъектXDTO("SalaryInfoCollection");
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СведенияОЗанятостиИЗаработнойПлате Цикл
		
		ОбъектXDTO.SalaryInfo.Добавить(SalaryInfo(СтрокаТабличнойЧасти));	
		
	КонецЦикла;
	
	Возврат ОбъектXDTO;
КонецФункции 

&НаСервере
Функция SalaryInfo(СтрокаТабличнойЧасти)
	// Создание объекта.
	ОбъектXDTO = СоздатьОбъектXDTO("SalaryInfo");
	
	ОбъектXDTO.PIN 						= СтрокаТабличнойЧасти.ФизЛицо.ИНН;
	ОбъектXDTO.ActivityCategoryCode 	= "";
	ОбъектXDTO.BeginDate 				= Формат(СтрокаТабличнойЧасти.ДатаНачалаРаботы, "ДФ=yyyy-MM-dd");
	ОбъектXDTO.Category 				= Строка(СтрокаТабличнойЧасти.Категория);
	ОбъектXDTO.CoefficientOfHighland 	= "";
	ОбъектXDTO.Days 					= Строка(СтрокаТабличнойЧасти.Дней);
	ОбъектXDTO.DaysActually 			= Строка(СтрокаТабличнойЧасти.ФактическиДней);
	ОбъектXDTO.EndDate 					= Формат(СтрокаТабличнойЧасти.ДатаОкончанияРаботы, "ДФ=yyyy-MM-dd");
	ОбъектXDTO.Name 					= СтрокаТабличнойЧасти.ФизЛицо.Наименование;
	ОбъектXDTO.Sum 						= Формат(?(Объект.Округление, Окр(СтрокаТабличнойЧасти.НачисленыеСтраховыеВзносы), СтрокаТабличнойЧасти.НачисленыеСтраховыеВзносы), "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");
	ОбъектXDTO.SumNPF 					= Формат(СтрокаТабличнойЧасти.НачсиленыеВзносыПоНПФ, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");
	ОбъектXDTO.SumOfAdditionalEarnings 	= Формат(?(Объект.Округление, Окр(СтрокаТабличнойЧасти.ДополнительныйФондОплатыТруда), СтрокаТабличнойЧасти.ДополнительныйФондОплатыТруда), "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");
	ОбъектXDTO.SumOfEarnings 			= Формат(СтрокаТабличнойЧасти.ФондОплатыТруда, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");
	
	Возврат ОбъектXDTO;
КонецФункции

&НаСервере
Функция PayerBalanceOfArrearsCollection()
	
	ОбъектXDTO = СоздатьОбъектXDTO("PayerBalanceOfArrearsCollection");
	
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Страховые взносы (кроме НПФ)",  Объект.ОбязательстваПоСтраховымВзносам));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Накопительный пенсионный фонд",   Объект.ОбязательстваПоПенсионномуФонду));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Пени и штрафы", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Отсроченные страховые взносы (кроме НПФ)", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Отсроченные страховые взносы - НПФ", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Отсроченные пени и штрафы", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Преемственная задолженность по взносам (кроме НПФ)", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Преемственная задолженность по взносам - НПФ", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Преемственная задолженность по пеням и штрафам", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Проценты по предоставлению отсрочки", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Переплата по страховым взносам (кроме НПФ)", Объект.ПереплатаПоСтраховымВзносам));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Переплата по санкциям", 0));
	ОбъектXDTO.PayerBalanceOfArrears.Добавить(PayerBalanceOfArrears("Переплата по НПФ", Объект.ПереплатаПоПенсионномуФонду));
	
	Возврат ОбъектXDTO;
КонецФункции 

&НаСервере
Функция PayerBalanceOfArrears(Наименование, Сумма)

	ОбъектXDTO = СоздатьОбъектXDTO("PayerBalanceOfArrears");
	
	ОбъектXDTO.Sum 				= Формат(Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0");
	ОбъектXDTO.TypeOfObligation = Наименование;
	
	Возврат ОбъектXDTO;
КонецФункции

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
