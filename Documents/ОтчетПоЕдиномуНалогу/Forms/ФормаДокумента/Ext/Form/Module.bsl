﻿
#Область ОбработчикиСобытийФормы

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
	
	Если Объект.КварталВыбран Тогда
		УстановитьЗаголовокДекорацияКвартал();	
	КонецЕсли;	
	
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

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьКвартал(Команда)
	
	СтруктураПараметры = Новый Структура();
	СтруктураПараметры.Вставить("НачалоПериода", НачалоКвартала(Объект.Дата));
	СтруктураПараметры.Вставить("КонецПериода",  КонецКвартала(Объект.Дата));

	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКварталЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", СтруктураПараметры, Элементы.ВыбратьКвартал, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ЕдиныйНалог.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнить", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные будут перезаполнены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнить(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ЕдиныйНалог.Очистить();
		ЗаполнитьНаСервере();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаСервере
Процедура ВыбратьКварталЗавершение(РезультатВыбора, ДопПараметры)

	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Дата = РезультатВыбора.НачалоПериода;
	Объект.КварталВыбран = Истина;
	
	УстановитьЗаголовокДекорацияКвартал(); 
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокДекорацияКвартал()

	Месяц = Месяц(Объект.Дата);
	Год = Формат(Год(Объект.Дата), "ЧГ=0");
	
	Если Месяц <= 3 Тогда     
		Элементы.ДекорацияКвартал.Заголовок = СтрШаблон(НСтр("ru = '1 квартал %1 года'"), Год);
		
	ИначеЕсли Месяц <= 6 Тогда
		Элементы.ДекорацияКвартал.Заголовок = СтрШаблон(НСтр("ru = '2 квартал %1 года'"), Год);
		
	ИначеЕсли Месяц <= 9 Тогда
		Элементы.ДекорацияКвартал.Заголовок = СтрШаблон(НСтр("ru = '3 квартал %1 года'"), Год);
		
	Иначе
		Элементы.ДекорацияКвартал.Заголовок = СтрШаблон(НСтр("ru = '4 квартал %1 года'"), Год);
	КонецЕсли;
КонецПроцедуры

// Процедура заполнения ТЧ "ЕдиныйНалог".
//
&НаСервере
Процедура ЗаполнитьНаСервере()

	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗакрытиеМесяца.ВидДеятельности КАК ВидДеятельности,
		|	ЗакрытиеМесяца.СуммаНаличная КАК СуммаНаличная,
		|	ЗакрытиеМесяца.СуммаБезналичная КАК СуммаБезналичная,
		|	ЗакрытиеМесяца.СуммаНаличнаяЕдиныйНалог КАК СуммаНаличнаяЕдиныйНалог,
		|	ЗакрытиеМесяца.СуммаБезналичнаяЕдиныйНалог КАК СуммаБезналичнаяЕдиныйНалог
		|ИЗ
		|	Документ.ЗакрытиеМесяца.ЕдиныйНалог КАК ЗакрытиеМесяца
		|ГДЕ
		|	ЗакрытиеМесяца.Ссылка.Проведен
		|	И ЗакрытиеМесяца.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ЗакрытиеМесяца.Ссылка.Организация = &Организация";	
	Запрос.УстановитьПараметр("НачалоПериода", 	Объект.Дата);
	Запрос.УстановитьПараметр("КонецПериода", 	КонецКвартала(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", 	Объект.Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Нет данных по единому налогу за указанный квартал! Заполнение отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;	
	КонецЕсли;	
	
	// ППТ - переработка производство торговля
	ППТ_СуммаНаличная 				= 0;
	ППТ_СуммаБезналичная 			= 0;
	ППТ_СуммаНаличнаяЕдиныйНалог 	= 0;
	ППТ_СуммаБезналичнаяЕдиныйНалог = 0;
	
	// П - прочее
	П_СуммаНаличная 				= 0;
	П_СуммаБезналичная 				= 0;
	П_СуммаНаличнаяЕдиныйНалог 		= 0;
	П_СуммаБезналичнаяЕдиныйНалог 	= 0;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ВидДеятельности = Перечисления.ВидыДеятельностиЕН.ПереработкаПроизводствоТорговля Тогда			
			ППТ_СуммаНаличная 				= ППТ_СуммаНаличная 				+ Выборка.СуммаНаличная;
			ППТ_СуммаБезналичная 			= ППТ_СуммаБезналичная 				+ Выборка.СуммаБезналичная;
			ППТ_СуммаНаличнаяЕдиныйНалог 	= ППТ_СуммаНаличнаяЕдиныйНалог 		+ Выборка.СуммаНаличнаяЕдиныйНалог;
			ППТ_СуммаБезналичнаяЕдиныйНалог = ППТ_СуммаБезналичнаяЕдиныйНалог 	+ Выборка.СуммаБезналичнаяЕдиныйНалог;
			
		Иначе
			П_СуммаНаличная 				= П_СуммаНаличная 					+ Выборка.СуммаНаличная;
			П_СуммаБезналичная 				= П_СуммаБезналичная 				+ Выборка.СуммаБезналичная;
			П_СуммаНаличнаяЕдиныйНалог 		= П_СуммаНаличнаяЕдиныйНалог 		+ Выборка.СуммаНаличнаяЕдиныйНалог;
			П_СуммаБезналичнаяЕдиныйНалог 	= П_СуммаБезналичнаяЕдиныйНалог 	+ Выборка.СуммаБезналичнаяЕдиныйНалог;
		КонецЕсли;			
	КонецЦикла;	
	
	// Строка по виду деятельности "ПереработкаПроизводствоТорговля"
	СтрокаТабличнойЧасти = Объект.ЕдиныйНалог.Добавить();
	СтрокаТабличнойЧасти.ВидДеятельности 				= Перечисления.ВидыДеятельностиЕН.ПереработкаПроизводствоТорговля;
	СтрокаТабличнойЧасти.СуммаНаличная 					= ППТ_СуммаНаличная;
	СтрокаТабличнойЧасти.СуммаБезналичная 				= ППТ_СуммаБезналичная;
	СтрокаТабличнойЧасти.СуммаНаличнаяЕдиныйНалог 		= ППТ_СуммаНаличнаяЕдиныйНалог;
	СтрокаТабличнойЧасти.СуммаБезналичнаяЕдиныйНалог 	= ППТ_СуммаБезналичнаяЕдиныйНалог;
	
	// Строка по виду деятельности "Прочее"
	СтрокаТабличнойЧасти = Объект.ЕдиныйНалог.Добавить();
	СтрокаТабличнойЧасти.ВидДеятельности 				= Перечисления.ВидыДеятельностиЕН.Прочее;
	СтрокаТабличнойЧасти.СуммаНаличная 					= П_СуммаНаличная;
	СтрокаТабличнойЧасти.СуммаБезналичная 				= П_СуммаБезналичная;
	СтрокаТабличнойЧасти.СуммаНаличнаяЕдиныйНалог 		= П_СуммаНаличнаяЕдиныйНалог;
	СтрокаТабличнойЧасти.СуммаБезналичнаяЕдиныйНалог 	= П_СуммаБезналичнаяЕдиныйНалог;
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

#КонецОбласти
