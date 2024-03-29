﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	// БП.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	УстановитьОтборПоОсновнойОрганизации();
	// Конец БП.ОтборыСписка
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ЭлектронныйСчетФактураВыписанный);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		// БП.ОтборыСписка
		СохранитьНастройкиОтборов();
		// Конец БП.ОтборыСписка
	КонецЕсли; 
КонецПроцедуры

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
Процедура СохранитьВЭлектроннойФорме(Команда)
	
	Отказ = Ложь;
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выделен ни один документ в списке, формирование файла xml отменено.'"),,,, Отказ);
	Иначе
		МассивСсылок = Новый Массив();
		Для Каждого СтрокаМассива Из ВыделенныеСтроки Цикл
			МассивСсылок.Добавить(СтрокаМассива);	
		КонецЦикла;
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для сохранения документа в электронной форме
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект, Новый Структура("МассивСсылок", МассивСсылок));
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьСохранение(МассивСсылок);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаЭлектронныхНомеровСФ(Команда)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Укажите файл для импорта данных'");
	Фильтр = НСтр("ru = 'eXtensible Markup Language (*.xml)|*.xml'");
	ДиалогВыбораФайла.Фильтр = Фильтр;
	
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ОбработатьНачалоВыбораФайлаЗагрузка", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла", ДиалогВыбораФайла)));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОткрытьПроводник(ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(ДополнительныеПараметры.ПолноеИмяФайла) Тогда 
		ФайловаяСистемаКлиент.ОткрытьПроводник(ДополнительныеПараметры.ПолноеИмяФайла);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНачалоВыбораФайлаЗагрузка(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;
	
	ЧтениеXML = Новый ЧтениеXML;
    ЧтениеXML.ОткрытьФайл(ДиалогВыбораФайла.ПолноеИмяФайла);
	
	Фабрика = Новый ФабрикаXDTO;
    ОбъектXDTO = Фабрика.ПрочитатьXML(ЧтениеXML);
	
	НомераСФПоGUID = Новый Соответствие();
	
	Попытка
		Если ТипЗнч(ОбъектXDTO.receipt) = Тип("ОбъектXDTO") Тогда	
			НомераСФПоGUID.Вставить(ОбъектXDTO.receipt.exchangeCode, ОбъектXDTO.receipt.invoiceNumber);	
		Иначе	
			Для Каждого receipt Из ОбъектXDTO.receipt Цикл   	
				НомераСФПоGUID.Вставить(receipt.exchangeCode, receipt.invoiceNumber);	
			КонецЦикла;	
		КонецЕсли;	
		
		ЗаполнитьНомерСФДокумента(НомераСФПоGUID);
		
	    ЧтениеXML.Закрыть();

		ТекстОповещения = НСтр("ru = 'Запись'");
		ТекстПояснения = НСтр("ru = 'Запись номеров ЭСФ в документы'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		Элементы.Список.Обновить();
		
	Исключение
		ТекстСообщения = НСтр("ru='Не удалось завершить загрузку файла.
			|Техническая информация об ошибке: %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));	
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);	
	КонецПопытки;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовОтборов

&НаКлиенте
Процедура ОтборБанковскийСчетОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("БанковскийСчет", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Товары.Номенклатура", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Валюта", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТребуетсяНастройкаАвторизацияИнтернетПоддержки()
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат Не МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
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
	
	ПродолжитьСохранение(ДополнительныеПараметры.МассивСсылок);	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьНомерСФДокумента(НомераСФПоGUID);// УникальныйИдентификатор, НомерСФ)

	Для Каждого ДанныеНомераСФ Из НомераСФПоGUID Цикл
		ДокументСсылка = Документы.ЭлектронныйСчетФактураВыписанный.ПолучитьСсылку(Новый УникальныйИдентификатор(ДанныеНомераСФ.Ключ));
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		
		Если ДокументОбъект = Неопределено Тогда 
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Нет документа ЭСФ с идентификатором %1. Номер ЭСФ %2 пропущен.'"), 
				ДанныеНомераСФ.Ключ, ДанныеНомераСФ.Значение);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Продолжить;	
		КонецЕсли;	
		
		ДокументОбъект.НомерЭСФ = ДанныеНомераСФ.Значение;	

		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ФормированиеДокументаВЭлектронномФормате

&НаКлиенте
Процедура ПродолжитьСохранение(МассивСсылок)
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите путь для сохранения файла'");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ДиалогОткрытияФайлаЗавершение", ЭтотОбъект, Новый Структура("МассивСсылок", МассивСсылок));
	ДиалогОткрытияФайла.Показать(Оповещение);

КонецПроцедуры // ПродолжитьСохранение()

&НаКлиенте
Процедура ДиалогОткрытияФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		Попытка
			ПараметрыФайлаXML = Новый Структура();
			ПараметрыФайлаXML.Вставить("МассивСсылок", ДополнительныеПараметры.МассивСсылок);
			ПараметрыФайлаXML.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
			
			СтруктураДанных = ДанныеФайлаXML(ПараметрыФайлаXML);
			
			Если СтруктураДанных = Неопределено Тогда
				Возврат;	
			КонецЕсли;	
			
		Исключение
			ТекстСообщения = НСтр("ru='Не удалось завершить формирование файла.
				|Техническая информация об ошибке: %1'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));	
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецПопытки;	
		
		// Формирование имени файла.
		КаталогФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВыбранныеФайлы[0]);
		ИмяФайла = СтруктураДанных.ИмяФайла;
		ПолноеИмяФайла = КаталогФайла + ИмяФайла;
		
		// Сохранение файла.
		Двоичное = ПолучитьИзВременногоХранилища(СтруктураДанных.АдресВременногоХранилища);
		Двоичное.Записать(ПолноеИмяФайла);	
		
		ТекстОповещения = НСтр("ru = 'Файл сформирован'");
		ТекстПояснения = ИмяФайла;
		ПоказатьОповещениеПользователя(
			ТекстОповещения, 
			Новый ОписаниеОповещения("ОткрытьПроводник", ЭтотОбъект, Новый Структура("ПолноеИмяФайла", ПолноеИмяФайла)), 
			ТекстПояснения, 
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеФайлаXML(ПараметрыФайлаXML)
	Возврат Документы.ЭлектронныйСчетФактураВыписанный.ФормированиеФайлаXML(ПараметрыФайлаXML);		
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если СтрНачинаетсяС(Команда.Имя, "ПодменюПечатьОбычное_Реестр") Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьОтборПоОсновнойОрганизации()

	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда 
			УстановитьМеткуИОтборСписка("Организация", Элементы.ОтборОрганизация.Родитель.Имя, ОсновнаяОрганизация);
		КонецЕсли;	
	Иначе
		УдаляемыеМетки = Новый СписокЗначений;
		Для Каждого Элемент Из Элементы.ОтборОрганизация.Родитель.ПодчиненныеЭлементы Цикл 
			Если СтрНайти(Элемент.Имя, "Метка_") > 0 Тогда 
				МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
				УдалитьМеткуОтбора(МеткаИД);
			КонецЕсли;	
		КонецЦикла;	
		
		УдалитьМеткиОтбора(УдаляемыеМетки);
		ОбновитьЭлементыМеток();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения = "" Тогда
		ПредставлениеЗначения = Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборыНажатие(Элемент)
	
	МеткаИД = 0;
	УдаляемыеМетки = Новый СписокЗначений;
	Для каждого Метка Из ДанныеМеток Цикл
		
		УдаляемыеМетки.Добавить(МеткаИД);
		МеткаИД = МеткаИД + 1;
	КонецЦикла;
	
	УдалитьМеткиОтбора(УдаляемыеМетки);
	
	ОбновитьЭлементыМеток();
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткиОтбора(Метки)
	
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список, Метки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыМеток()
	
	РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
