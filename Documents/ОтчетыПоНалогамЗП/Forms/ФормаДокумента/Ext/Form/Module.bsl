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
	
КонецПроцедуры // ПриЧтенииНаСервере()

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыЕжеквартальныеПлатежиВСФ

&НаКлиенте
Процедура ЕжеквартальныеПлатежиВСФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	НаименованиеДинамическогоСписка = "ЕжеквартальныеПлатежиВСФВыбор";
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
Процедура ЗаполнитьКвартальныйОтчетСФ(Команда)
	
	Если КонецМесяца(Объект.Дата) <> КонецКвартала(Объект.Дата) Тогда 
		ТекстСообщения = НСтр("ru = 'Раздел заполняется раз в квартал. Заполнение отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.СоцфондПоказателиЕжеквартальные",,);		
		Возврат;
	КонецЕсли;
	
	Если Объект.СоцфондПоказателиЕжеквартальные.Количество() > 0 Или  Объект.СоцфондОбязательстваИВыполненияЕжеквартальный.Количество() > 0 
		Или Объект.ПоступлениеСредствЕжеквартальное.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличныеЧастиКвартальныйОтчетСФ", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе		
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьКвартальныйОтчетСФНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ПодоходныйНалог.Количество() > 0 Или Объект.СведенияОЗанятостиИЗаработнойПлате.Количество() > 0 Или  Объект.ФондОплатыТрудаПоКатегориям.Количество() > 0 
		Или Объект.СоцфондПоказателиЕжеквартальные.Количество() > 0 
		Или Объект.СоцфондОбязательстваИВыполненияЕжеквартальный.Количество() > 0 
		Или Объект.ПоступлениеСредствЕжеквартальное.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьВсеТабличныеЧасти", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьПодоходныйНалогНаСервере();
		ЗаполнитьСоцфондНаСервере();
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьПодоходныйНалогПриложениеНаСервере();
			ЗаполнитьКвартальныйОтчетСФНаСервере();
		КонецЕсли;
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
Процедура ОтветНаВопросЗаполнитьТабличныеЧастиКвартальныйОтчетСФ(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.СоцфондОбязательстваИВыполненияЕжеквартальный.Очистить();
		Объект.ПоступлениеСредствЕжеквартальное.Очистить();
		ЗаполнитьКвартальныйОтчетСФНаСервере();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьВсеТабличныеЧасти(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Объект.СоцфондОбязательстваИВыполненияЕжеквартальный.Очистить();
		Объект.ПоступлениеСредствЕжеквартальное.Очистить();

		ЗаполнитьПодоходныйНалогНаСервере();
		ЗаполнитьСоцфондНаСервере();
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда 
			ЗаполнитьПодоходныйНалогПриложениеНаСервере();
			ЗаполнитьКвартальныйОтчетСФНаСервере();
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
	
	ЕжеквартальныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоГода(Объект.Дата));
	ЕжеквартальныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецМесяца(Объект.Дата));
	ЕжеквартальныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("СписокСчетов", МассивСчетов);
	ЕжеквартальныеПлатежиВСФ.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);

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
	
	Если НаименованиеДинамическогоСписка = "ЕжеквартальныеПлатежиВСФВыбор" Тогда
		Схема = Элементы.ЕжеквартальныеПлатежиВСФ.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
		Настройки = Элементы.ЕжеквартальныеПлатежиВСФ.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	Иначе
		Схема = Элементы.ЕжемесячныеПлатежиВСФ.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
		Настройки = Элементы.ЕжемесячныеПлатежиВСФ.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КонецЕсли;
	
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
Процедура ЗаполнитьКвартальныйОтчетСФНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьКвартальныйОтчетСФ();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

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


