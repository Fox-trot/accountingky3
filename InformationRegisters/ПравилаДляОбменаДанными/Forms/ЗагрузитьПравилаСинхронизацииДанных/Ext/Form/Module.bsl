﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ВнешниеРесурсыРазрешены;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = Параметры.ИмяПланаОбмена;
	
	Если Не ЗначениеЗаполнено(ИмяПланаОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = СтрЗаменить(Заголовок, "%1", Метаданные.ПланыОбмена[ИмяПланаОбмена].Синоним);
	
	ОбновитьИнформациюОПравилах();
	
	Элементы.ГруппаОтладки.Доступность = (ИсточникПравил = "ЗагруженныеИзФайла");
	Элементы.ГруппаНастройкиОтладки.Доступность = РежимОтладки;
	Элементы.ИсточникФайл.Доступность = (ИсточникПравил = "ЗагруженныеИзФайла");
	
	СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
	
	ИмяПрограммы = Метаданные.ПланыОбмена[ИмяПланаОбмена].Синоним;
	РасположениеКомплектаПравил = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена,
		"ПутьКФайлуКомплектаПравилНаПользовательскомСайте, ПутьКФайлуКомплектаПравилВКаталогеШаблонов");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ШаблонПодсказки = НСтр("ru = 'Комплект правил можно скачать с %1
		|или найти в %2'");
	
	ШаблонКаталогОбновлений = НСтр("ru = 'каталоге поставки программы ""%1""'");
	ШаблонКаталогОбновлений = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонКаталогОбновлений, ИмяПрограммы);
	
	ШаблонПользовательскийСайт = НСтр("ru = 'сайта поддержки пользователей системы ""1С:Предприятие 8""'");
	Если Не ПустаяСтрока(РасположениеКомплектаПравил.ПутьКФайлуКомплектаПравилНаПользовательскомСайте) Тогда
		ШаблонПользовательскийСайт = Новый ФорматированнаяСтрока(ШаблонПользовательскийСайт,,,, РасположениеКомплектаПравил.ПутьКФайлуКомплектаПравилНаПользовательскомСайте);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ШаблонПодсказки",            ШаблонПодсказки);
	ДополнительныеПараметры.Вставить("ШаблонКаталогОбновлений",    ШаблонКаталогОбновлений);
	ДополнительныеПараметры.Вставить("ШаблонПользовательскийСайт", ШаблонПользовательскийСайт);
	
	Если Не ПустаяСтрока(РасположениеКомплектаПравил.ПутьКФайлуКомплектаПравилВКаталогеШаблонов) Тогда
		
		ДополнительныеПараметры.Вставить("КаталогПоУмолчанию",                КаталогAppData() + "1C\1Cv8\tmplts\");
		ДополнительныеПараметры.Вставить("ПользовательскиеНастройкиШаблонов", КаталогAppData() + "1C\1CEStart\1CEStart.cfg");
		ДополнительныеПараметры.Вставить("РасположениеФайла",                 "");
		
		ТекстПредложения = НСтр("ru = 'Для открытия каталога необходимо необходимо установить расширение работы с файлами.'");
		Оповещение = Новый ОписаниеОповещения("ПослеПроверкиРасширенияРаботыСФайлами", ЭтотОбъект, ДополнительныеПараметры);
		ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения);
		
	Иначе
		УстановитьЗаголовокИнформацииОПолучении(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ПослеПроверкиРасширенияРаботыСФайлами(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		Файл = Новый Файл();
		ДополнительныеПараметры.Вставить("СледующееОповещение", Новый ОписаниеОповещения("ОпределениеСуществованияФайла", ЭтотОбъект, ДополнительныеПараметры));
		Оповещение = Новый ОписаниеОповещения("ИнициализироватьФайл", ЭтотОбъект, ДополнительныеПараметры);
		Файл.НачатьИнициализацию(Оповещение, ДополнительныеПараметры.ПользовательскиеНастройкиШаблонов);
	Иначе
		УстановитьЗаголовокИнформацииОПолучении(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ИнициализироватьФайл(Файл, ДополнительныеПараметры) Экспорт
	Файл.НачатьПроверкуСуществования(ДополнительныеПараметры.СледующееОповещение);
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ОпределениеСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	
	НайденныйКаталог = Неопределено;
	
	Если Существует Тогда
		
		Текст = Новый ЧтениеТекста(ДополнительныеПараметры.ПользовательскиеНастройкиШаблонов, КодировкаТекста.UTF16);
		Стр = "";
		
		Пока Стр <> Неопределено Цикл
			Стр = Текст.ПрочитатьСтроку();
			Если Стр = Неопределено Тогда
				Прервать;
			КонецЕсли;
			Если СтрНайти(ВРег(Стр), ВРег("ConfigurationTemplatesLocation")) = 0 Тогда
				Продолжить;
			КонецЕсли;
			ПозицияРазделителя = СтрНайти(Стр, "=");
			Если ПозицияРазделителя = 0 Тогда
				Продолжить;
			КонецЕсли;
			НайденныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СокрЛП(Сред(Стр, ПозицияРазделителя + 1)));
			Прервать;
		КонецЦикла;
		
	КонецЕсли;
	
	Если НайденныйКаталог <> Неопределено Тогда
		ДополнительныеПараметры.РасположениеФайла = НайденныйКаталог + РасположениеКомплектаПравил.ПутьКФайлуКомплектаПравилВКаталогеШаблонов;
	Иначе
		ДополнительныеПараметры.РасположениеФайла = ДополнительныеПараметры.КаталогПоУмолчанию + РасположениеКомплектаПравил.ПутьКФайлуКомплектаПравилВКаталогеШаблонов
	КонецЕсли;
	
	Файл = Новый Файл();
	ДополнительныеПараметры.СледующееОповещение = Новый ОписаниеОповещения("ОпределениеСуществованияКаталога", ЭтотОбъект, ДополнительныеПараметры);
	Оповещение = Новый ОписаниеОповещения("ИнициализироватьФайл", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьИнициализацию(Оповещение, ДополнительныеПараметры.РасположениеФайла);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ОпределениеСуществованияКаталога(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		ДополнительныеПараметры.ШаблонКаталогОбновлений = Новый ФорматированнаяСтрока(ДополнительныеПараметры.ШаблонКаталогОбновлений,,,,
			ДополнительныеПараметры.РасположениеФайла);
	КонецЕсли;
	
	УстановитьЗаголовокИнформацииОПолучении(ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура УстановитьЗаголовокИнформацииОПолучении(ДополнительныеПараметры)
	ТекстПодсказки = ПодставитьПараметрыВФорматированнуюСтроку(ДополнительныеПараметры.ШаблонПодсказки, 
		ДополнительныеПараметры.ШаблонПользовательскийСайт,
		ДополнительныеПараметры.ШаблонКаталогОбновлений);
	Элементы.ДекорацияИнформацияОПолученииПравил.Заголовок = ТекстПодсказки;
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	ЕстьНезаполненныеПоля = Ложь;
	
	Если РежимОтладки Тогда
		
		Если РежимОтладкиВыгрузки Тогда
			
			СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаОбработкиДляОтладкиВыгрузки);
			ИмяФайла = СтруктураИмениФайла.ИмяБезРасширения;
			
			Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
				
				СтрокаСообщения = НСтр("ru = 'Не задано имя файла внешней обработки.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,, "ИмяФайлаОбработкиДляОтладкиВыгрузки",, ЕстьНезаполненныеПоля);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если РежимОтладкиЗагрузки Тогда
			
			СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаОбработкиДляОтладкиЗагрузки);
			ИмяФайла = СтруктураИмениФайла.ИмяБезРасширения;
			
			Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
				
				СтрокаСообщения = НСтр("ru = 'Не задано имя файла внешней обработки.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,, "ИмяФайлаОбработкиДляОтладкиЗагрузки",, ЕстьНезаполненныеПоля);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если РежимПротоколированияОбменаДанными Тогда
			
			СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаПротоколаОбмена);
			ИмяФайла = СтруктураИмениФайла.ИмяБезРасширения;
			
			Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
				
				СтрокаСообщения = НСтр("ru = 'Не задано имя файла протокола обмена.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,, "ИмяФайлаПротоколаОбмена",, ЕстьНезаполненныеПоля);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Не ЕстьНезаполненныеПоля;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсточникПравилПриИзменении(Элемент)
	
	Элементы.ГруппаОтладки.Доступность = (ИсточникПравил = "ЗагруженныеИзФайла");
	Элементы.ИсточникФайл.Доступность = (ИсточникПравил = "ЗагруженныеИзФайла");
	
	Если ИсточникПравил = "ТиповыеИзКонфигурации" Тогда
		
		РежимОтладки = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтладкуВыгрузкиПриИзменении(Элемент)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	Элементы.ВнешняяОбработкаДляОтладкиВыгрузки.Доступность = РежимОтладкиВыгрузки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяОбработкаДляОтладкиВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Внешняя обработка(*.epf)'") + "|*.epf" );
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(ЭтотОбъект, "ИмяФайлаОбработкиДляОтладкиВыгрузки", СтандартнаяОбработка, НастройкиДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяОбработкаДляОтладкиЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Внешняя обработка(*.epf)'") + "|*.epf" );
	
	СтандартнаяОбработка = Ложь;
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(ЭтотОбъект, "ИмяФайлаОбработкиДляОтладкиЗагрузки", СтандартнаяОбработка, НастройкиДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтладкуЗагрузкиПриИзменении(Элемент)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	Элементы.ВнешняяОбработкаДляОтладкиЗагрузки.Доступность = РежимОтладкиЗагрузки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПротоколированиеОбменаДаннымиПриИзменении(Элемент)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	Элементы.ФайлПротоколаОбмена.Доступность = РежимПротоколированияОбменаДанными;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлПротоколаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Текстовый документ(*.txt)'")+ "|*.txt" );
	НастройкиДиалога.Вставить("ПроверятьСуществованиеФайла", Ложь);
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(ЭтотОбъект, "ИмяФайлаПротоколаОбмена", СтандартнаяОбработка, НастройкиДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлПротоколаОбменаОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(ЭтотОбъект, "ИмяФайлаПротоколаОбмена", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРежимОтладкиПриИзменении(Элемент)
	
	ИзмененыНастройкиРежимаОтладки = Истина;
	Элементы.ГруппаНастройкиОтладки.Доступность = РежимОтладки;
	
КонецПроцедуры

&НаКлиенте
Процедура НеОстанавливатьПоОшибкеПриИзменении(Элемент)
	ИзмененыНастройкиРежимаОтладки = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияОПолученииПравилОбработкаНавигационнойСсылки(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "http") = 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьКаталогСПоставкамиКонфигураций", ЭтотОбъект);
		НачатьЗапускПриложения(Оповещение, НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ОткрытьКаталогСПоставкамиКонфигураций(КодВозврата, ДополнительныеПараметры) Экспорт
	// Обработка не требуется.
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПравила(Команда)
	
	// Из файла с клиента
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаПравил);
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Укажите архив с правилами обмена'"));
	ПараметрыДиалога.Вставить("Фильтр", НСтр("ru = 'Архивы ZIP (*.zip)'") + "|*.zip");
	ПараметрыДиалога.Вставить("ПолноеИмяФайла", ЧастиИмени.ПолноеИмя);
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьПравилаЗавершение", ЭтотОбъект);
	ОбменДаннымиКлиент.ВыбратьИПередатьФайлНаСервер(Оповещение, ПараметрыДиалога, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПравила(Команда)
	
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаПравил);

	// Выгружаем как архив
	АдресХранения = ПолучитьАдресВременногоХранилищаАрхиваПравилНаСервере();
	
	Если ПустаяСтрока(АдресХранения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ЧастиИмени.ИмяБезРасширения) Тогда
		ПолноеИмяФайла = НСтр("ru = 'Правила конвертации'");
	Иначе
		ПолноеИмяФайла = ЧастиИмени.ИмяБезРасширения;
	КонецЕсли;
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Режим", РежимДиалогаВыбораФайла.Сохранение);
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Укажите в какой файл выгрузить правила'") );
	ПараметрыДиалога.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	ПараметрыДиалога.Вставить("Фильтр", НСтр("ru = 'Архивы ZIP (*.zip)'") + "|*.zip");
	
	ПолучаемыйФайл = Новый Структура("Имя, Хранение", ПолноеИмяФайла, АдресХранения);
	
	ОбменДаннымиКлиент.ВыбратьИСохранитьФайлНаКлиенте(ПолучаемыйФайл, ПараметрыДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
		
	Если ИсточникПравил = "ТиповыеИзКонфигурации" Тогда
		ПередЗагрузкойПравил(Неопределено, "");
	Иначе
		Если ИсточникПравилКонвертации = ПредопределенноеЗначение("Перечисление.ИсточникиПравилДляОбменаДанными.МакетКонфигурации") Тогда
			
			ОписаниеОшибки = НСтр("ru = 'Правила из файла не загружены. Закрытие приведет к использованию типовых правил конвертации.
			|Использовать типовые правила конвертации?'");
			
			Оповещение = Новый ОписаниеОповещения("ЗакрытьФормуЗагрузкиПравил", ЭтотОбъект);
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("Использовать", НСтр("ru = 'Использовать'"));
			Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
			
			ПараметрыФормы = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
			ПараметрыФормы.КнопкаПоУмолчанию = "Использовать";
			ПараметрыФормы.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
			
			СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, ОписаниеОшибки, Кнопки, ПараметрыФормы);
		Иначе
			Если ИзмененыНастройкиРежимаОтладки Тогда
				ЗагрузитьНастройкиРежимаОтладкиНаСервере();
			КонецЕсли;
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьПравилаЗавершение(Знач РезультатПомещенияФайлов, Знач ДополнительныеПараметры) Экспорт
	
	АдресПомещенногоФайла = РезультатПомещенияФайлов.Хранение;
	ТекстОшибки           = РезультатПомещенияФайлов.ОписаниеОшибки;
	
	Если ПустаяСтрока(ТекстОшибки) И ПустаяСтрока(АдресПомещенногоФайла) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка передачи файла настроек синхронизации данных на сервер'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
		
	// Успешно передали файл, загружаем на сервере.
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(РезультатПомещенияФайлов.Имя);
	
	Если НРег(ЧастиИмени.Расширение) <> ".zip" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректный формат файла комплекта правил. Ожидается zip архив, содержащий три файла:
			|ExchangeRules.xml - правила конвертации для текущей программы;
			|CorrespondentExchangeRules.xml - правила конвертации для программы-корреспондента;
			|RegistrationRules.xml - правила регистрации для текущей программы.'"));
	КонецЕсли;
	
	ПередЗагрузкойПравил(АдресПомещенногоФайла, ЧастиИмени.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуПравил(Знач АдресПомещенногоФайла, Знач ИмяФайла, ОписаниеОшибки = Неопределено)
	
	Отказ = Ложь;
	ИзмененыНастройкиРежимаОтладки = Ложь;
	
	ЗагрузитьПравилаНаСервере(Отказ, АдресПомещенногоФайла, ИмяФайла, ОписаниеОшибки);
	
	Если ТипЗнч(ОписаниеОшибки) <> Тип("Булево") И ОписаниеОшибки <> Неопределено Тогда
		
		Кнопки = Новый СписокЗначений;
		
		Если ОписаниеОшибки.ВидОшибки = "НекорректнаяКонфигурация" Тогда
			Кнопки.Добавить("Отмена", НСтр("ru = 'Закрыть'"));
		Иначе
			Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
			Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("АдресПомещенногоФайла", АдресПомещенногоФайла);
		ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
		Оповещение = Новый ОписаниеОповещения("ПослеПроверкиПравилКонвертацииНаСовместимость", ЭтотОбъект, ДополнительныеПараметры);
		
		ПараметрыФормы = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
		ПараметрыФормы.КнопкаПоУмолчанию = "Отмена";
		ПараметрыФормы.Картинка = ОписаниеОшибки.Картинка;
		ПараметрыФормы.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
		Если ОписаниеОшибки.ВидОшибки = "НекорректнаяКонфигурация" Тогда
			ПараметрыФормы.Заголовок = НСтр("ru = 'Правила не могут быть загружены'");
		Иначе
			ПараметрыФормы.Заголовок = НСтр("ru = 'Синхронизация данных может работать некорректно'");
		КонецЕсли;
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, ОписаниеОшибки.ТекстОшибки, Кнопки, ПараметрыФормы);
		
	ИначеЕсли Отказ Тогда
		ТекстОшибки = НСтр("ru = 'В процессе загрузки правил были обнаружены ошибки.
			|Перейти в журнал регистрации?'");
		Оповещение = Новый ОписаниеОповещения("ПоказатьЖурналРегистрацииПриОшибке", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстОшибки, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
	Иначе
		ПоказатьОповещениеПользователя(,, НСтр("ru = 'Правила успешно загружены в информационную базу.'"));
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЖурналРегистрацииПриОшибке(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПравилаНаСервере(Отказ, АдресВременногоХранилища, ИмяФайлаПравил, ОписаниеОшибки)
	
	ИсточникПравилКомплекта = ?(ИсточникПравил = "ТиповыеИзКонфигурации",
		Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации, Перечисления.ИсточникиПравилДляОбменаДанными.Файл);
	
	ЗаписьПравилКонвертации                               = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьМенеджерЗаписи();
	ЗаписьПравилКонвертации.ВидПравил                     = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов;
	ЗаписьПравилКонвертации.ИмяМакетаПравил               = ИмяМакетаПравилКонвертации;
	ЗаписьПравилКонвертации.ИмяМакетаПравилКорреспондента = ИмяМакетаПравилКорреспондента;
	ЗаписьПравилКонвертации.ИнформацияОПравилах           = ИнформацияОПравилахКонвертации;
	
	ЗаполнитьЗначенияСвойств(ЗаписьПравилКонвертации, ЭтотОбъект);
	ЗаписьПравилКонвертации.ИсточникПравил = ИсточникПравилКомплекта;
	
	ЗаписьПравилРегистрации                     = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьМенеджерЗаписи();
	ЗаписьПравилРегистрации.ВидПравил           = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов;
	ЗаписьПравилРегистрации.ИмяМакетаПравил     = ИмяМакетаПравилРегистрации;
	ЗаписьПравилРегистрации.ИнформацияОПравилах = ИнформацияОПравилахРегистрации;
	ЗаписьПравилРегистрации.ИмяФайлаПравил      = ИмяФайлаПравил;
	ЗаписьПравилРегистрации.ИмяПланаОбмена      = ИмяПланаОбмена;
	ЗаписьПравилРегистрации.ИсточникПравил      = ИсточникПравилКомплекта;
	
	СтруктураЗаписейРегистра = Новый Структура();
	СтруктураЗаписейРегистра.Вставить("ЗаписьПравилКонвертации", ЗаписьПравилКонвертации);
	СтруктураЗаписейРегистра.Вставить("ЗаписьПравилРегистрации", ЗаписьПравилРегистрации);
	
	РегистрыСведений.ПравилаДляОбменаДанными.ЗагрузитьКомплектПравил(Отказ, СтруктураЗаписейРегистра,
		ОписаниеОшибки, АдресВременногоХранилища, ИмяФайлаПравил);
	
	Если Не Отказ Тогда
		
		ЗаписьПравилКонвертации.Записать();
		ЗаписьПравилРегистрации.Записать();
		
		Модифицированность = Ложь;
		
		// Кэш открытых сеансов для механизма регистрации стал неактуальным.
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьИнформациюОПравилах();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресВременногоХранилищаАрхиваПравилНаСервере()
	
	// Создаем временный каталог на сервере и формируем пути к файлам и папкам.
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла("");
	СоздатьКаталог(ИмяВременнойПапки);
	
	ПутьКФайлу               = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + "ExchangeRules";
	ПутьКФайлуКорреспондента = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + "CorrespondentExchangeRules";
	ПутьКФайлуРегистрации    = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + "RegistrationRules";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПравилаДляОбменаДанными.ПравилаXML,
		|	ПравилаДляОбменаДанными.ПравилаXMLКорреспондента,
		|	ПравилаДляОбменаДанными.ВидПравил
		|ИЗ
		|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
		|ГДЕ
		|	ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена";
	
	Запрос.УстановитьПараметр("ИмяПланаОбмена", ИмяПланаОбмена);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		НСтрока = НСтр("ru = 'Не удалось получить правила обмена.'");
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока);
		УдалитьФайлы(ИмяВременнойПапки);
		Возврат "";
		
	Иначе
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
				
				// Получаем, сохраняем и архивируем файл правил конвертации во временном каталоге.
				ДвоичныеДанныеПравил = Выборка.ПравилаXML.Получить();
				ДвоичныеДанныеПравил.Записать(ПутьКФайлу + ".xml");
				
				// Получаем, сохраняем и архивируем файл правил конвертации корреспондента во временном каталоге.
				ДвоичныеДанныеПравилКорреспондента = Выборка.ПравилаXMLКорреспондента.Получить();
				ДвоичныеДанныеПравилКорреспондента.Записать(ПутьКФайлуКорреспондента + ".xml");
				
			Иначе
				// Получаем, сохраняем и архивируем файл правил регистрации во временном каталоге.
				ДвоичныеДанныеПравилРегистрации = Выборка.ПравилаXML.Получить();
				ДвоичныеДанныеПравилРегистрации.Записать(ПутьКФайлуРегистрации + ".xml");
			КонецЕсли;
			
		КонецЦикла;
		
		МаскаУпаковкиФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + "*.xml";
		ОбменДаннымиСервер.ЗапаковатьВZipФайл(ПутьКФайлу + ".zip", МаскаУпаковкиФайлов);
		
		// Помещаем архив правил в хранилище.
		ДвоичныеДанныеАрхиваПравил = Новый ДвоичныеДанные(ПутьКФайлу + ".zip");
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанныеАрхиваПравил);
		УдалитьФайлы(ИмяВременнойПапки);
		
		Возврат АдресВременногоХранилища;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОПравилах()
	
	ИнформацияОПравилах();
	
	ИсточникПравил = ?(ИсточникПравилРегистрации = Перечисления.ИсточникиПравилДляОбменаДанными.Файл
		ИЛИ ИсточникПравилКонвертации = Перечисления.ИсточникиПравилДляОбменаДанными.Файл,
		"ЗагруженныеИзФайла", "ТиповыеИзКонфигурации");
	
	ИнформацияОПравилахОбщая = "[ИнформацияОбИспользовании]
		|
		|[ИнформацияОПравилахРегистрации]
		|
		|[ИнформацияОПравилахКонвертации]";
	
	Если ИсточникПравил = "ЗагруженныеИзФайла" Тогда
		ИнформацияОбИспользовании = НСтр("ru = 'Используются правила загруженные из файла.'");
	Иначе
		ИнформацияОбИспользовании = НСтр("ru = 'Используются типовые правила из состава конфигурации.'");
	КонецЕсли;
	
	ИнформацияОПравилахОбщая = СтрЗаменить(ИнформацияОПравилахОбщая, "[ИнформацияОбИспользовании]", ИнформацияОбИспользовании);
	ИнформацияОПравилахОбщая = СтрЗаменить(ИнформацияОПравилахОбщая, "[ИнформацияОПравилахКонвертации]", ИнформацияОПравилахКонвертации);
	ИнформацияОПравилахОбщая = СтрЗаменить(ИнформацияОПравилахОбщая, "[ИнформацияОПравилахРегистрации]", ИнформацияОПравилахРегистрации);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОПравилах()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПланаОбмена", ИмяПланаОбмена);
	
	Запрос.Текст = "ВЫБРАТЬ
		|	ПравилаДляОбменаДанными.ИмяМакетаПравил КАК ИмяМакетаПравилКонвертации,
		|	ПравилаДляОбменаДанными.ИмяМакетаПравилКорреспондента КАК ИмяМакетаПравилКорреспондента,
		|	ПравилаДляОбменаДанными.ИмяФайлаОбработкиДляОтладкиВыгрузки,
		|	ПравилаДляОбменаДанными.ИмяФайлаОбработкиДляОтладкиЗагрузки,
		|	ПравилаДляОбменаДанными.ИмяФайлаПравил КАК ИмяФайлаПравилКонвертации,
		|	ПравилаДляОбменаДанными.ИмяФайлаПротоколаОбмена,
		|	ПравилаДляОбменаДанными.ИнформацияОПравилах КАК ИнформацияОПравилахКонвертации,
		|	ПравилаДляОбменаДанными.ИспользоватьФильтрВыборочнойРегистрацииОбъектов,
		|	ПравилаДляОбменаДанными.ИсточникПравил КАК ИсточникПравилКонвертации,
		|	ПравилаДляОбменаДанными.НеОстанавливатьПоОшибке,
		|	ПравилаДляОбменаДанными.РежимОтладки,
		|	ПравилаДляОбменаДанными.РежимОтладкиВыгрузки,
		|	ПравилаДляОбменаДанными.РежимОтладкиЗагрузки,
		|	ПравилаДляОбменаДанными.РежимПротоколированияОбменаДанными
		|ИЗ
		|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
		|ГДЕ
		|	ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
		|	И ПравилаДляОбменаДанными.ВидПравил = ЗНАЧЕНИЕ(Перечисление.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов)";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
		|	ПравилаДляОбменаДанными.ИмяМакетаПравил КАК ИмяМакетаПравилРегистрации,
		|	ПравилаДляОбменаДанными.ИмяФайлаПравил КАК ИмяФайлаПравилРегистрации,
		|	ПравилаДляОбменаДанными.ИнформацияОПравилах КАК ИнформацияОПравилахРегистрации,
		|	ПравилаДляОбменаДанными.ИсточникПравил КАК ИсточникПравилРегистрации
		|ИЗ
		|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
		|ГДЕ
		|	ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
		|	И ПравилаДляОбменаДанными.ВидПравил = ЗНАЧЕНИЕ(Перечисление.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗагрузкойПравил(Знач АдресПомещенногоФайла, Знач ИмяФайла)
	
	Если Не ПроверитьЗаполнениеНаКлиенте() Тогда
		Возврат;
	КонецЕсли;
	
	Если ВнешниеРесурсыРазрешены <> Истина Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("АдресПомещенногоФайла", АдресПомещенногоФайла);
		ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("РазрешитьВнешнийРесурсЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов();
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
		Иначе
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	ВнешниеРесурсыРазрешены = Ложь;
	
	ВыполнитьЗагрузкуПравил(АдресПомещенногоФайла, ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВнешнийРесурсЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		ПередЗагрузкойПравил(ДополнительныеПараметры.АдресПомещенногоФайла, ДополнительныеПараметры.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов()
	
	ЗапросыРазрешений = Новый Массив;
	ПравилаРегистрацииИзФайла = (ИсточникПравил <> "ТиповыеИзКонфигурации");
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	СтруктураЗаписи.Вставить("РежимОтладки", РежимОтладки);
	СтруктураЗаписи.Вставить("РежимОтладкиВыгрузки", РежимОтладкиВыгрузки);
	СтруктураЗаписи.Вставить("РежимОтладкиЗагрузки", РежимОтладкиЗагрузки);
	СтруктураЗаписи.Вставить("РежимПротоколированияОбменаДанными", РежимПротоколированияОбменаДанными);
	СтруктураЗаписи.Вставить("ИмяФайлаОбработкиДляОтладкиВыгрузки", ИмяФайлаОбработкиДляОтладкиВыгрузки);
	СтруктураЗаписи.Вставить("ИмяФайлаОбработкиДляОтладкиЗагрузки", ИмяФайлаОбработкиДляОтладкиЗагрузки);
	СтруктураЗаписи.Вставить("ИмяФайлаПротоколаОбмена", ИмяФайлаПротоколаОбмена);
	РегистрыСведений.ПравилаДляОбменаДанными.ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, СтруктураЗаписи, Истина, ПравилаРегистрацииИзФайла);
	Возврат ЗапросыРазрешений;
	
КонецФункции

&НаКлиенте
// Возвращает форматированную строку, построенную по шаблону, например "%1 пошел в %2".
//
// Параметры:
//     Шаблон - Строка - заготовка для формирования.
//     Строка1 - Строка, ФорматированнаяСтрока, Картинка, Неопределено - подставляемое значение.
//     Строка2 - Строка, ФорматированнаяСтрока, Картинка, Неопределено - подставляемое значение.
//
// Возвращаемое значение:
//     ФорматированнаяСтрока - сформированная по входящим параметрам.
//
Функция ПодставитьПараметрыВФорматированнуюСтроку(Знач Шаблон,
	Знач Строка1 = Неопределено, Знач Строка2 = Неопределено)
	
	ЧастиСтроки = Новый Массив;
	ДопустимыеТипы = Новый ОписаниеТипов("Строка, ФорматированнаяСтрока, Картинка");
	Начало = 1;
	
	Пока Истина Цикл
		
		Фрагмент = Сред(Шаблон, Начало);
		
		Позиция = СтрНайти(Фрагмент, "%");
		
		Если Позиция = 0 Тогда
			
			ЧастиСтроки.Добавить(Фрагмент);
			
			Прервать;
			
		КонецЕсли;
		
		Следующий = Сред(Фрагмент, Позиция + 1, 1);
		
		Если Следующий = "1" Тогда
			
			Значение = Строка1;
			
		ИначеЕсли Следующий = "2" Тогда
			
			Значение = Строка2;
			
		ИначеЕсли Следующий = "%" Тогда
			
			Значение = "%";
			
		Иначе
			
			Значение = Неопределено;
			
			Позиция  = Позиция - 1;
			
		КонецЕсли;
		
		ЧастиСтроки.Добавить(Лев(Фрагмент, Позиция - 1));
		
		Если Значение <> Неопределено Тогда
			
			Значение = ДопустимыеТипы.ПривестиЗначение(Значение);
			
			Если Значение <> Неопределено Тогда
				
				ЧастиСтроки.Добавить( Значение );
				
			КонецЕсли;
			
		КонецЕсли;
		
		Начало = Начало + Позиция + 1;
		
	КонецЦикла;
	
	Возврат Новый ФорматированнаяСтрока(ЧастиСтроки);
	
КонецФункции

// Определение каталога "Мои документы" текущего пользователя Windows.
//
&НаКлиенте
Функция КаталогAppData()
	
	App = Новый COMОбъект("Shell.Application");
	Folder = App.Namespace(26);
	Результат = Folder.Self.Path;
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Результат);
	
КонецФункции

&НаКлиенте
Процедура ПослеПроверкиПравилКонвертацииНаСовместимость(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат.Значение = "Продолжить" Тогда
		
		ОписаниеОшибки = Истина;
		ВыполнитьЗагрузкуПравил(ДополнительныеПараметры.АдресПомещенногоФайла, ДополнительныеПараметры.ИмяФайла, ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуЗагрузкиПравил(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено И Результат.Значение = "Использовать" Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиРежимаОтладкиНаСервере()
	ЗаписиПравилКонвертации = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьНаборЗаписей();
	ЗаписиПравилКонвертации.Отбор.ВидПравил.Установить(Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов);
	ЗаписиПравилКонвертации.Отбор.ИмяПланаОбмена.Установить(ИмяПланаОбмена);
	ЗаписиПравилКонвертации.Прочитать();
	Если ЗаписиПравилКонвертации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ЗаписьПравил = ЗаписиПравилКонвертации[0];
	ЗаписьПравил.ИмяФайлаОбработкиДляОтладкиВыгрузки = ИмяФайлаОбработкиДляОтладкиВыгрузки;
	ЗаписьПравил.ИмяФайлаОбработкиДляОтладкиЗагрузки = ИмяФайлаОбработкиДляОтладкиЗагрузки;
	ЗаписьПравил.ИмяФайлаПротоколаОбмена = ИмяФайлаПротоколаОбмена;
	ЗаписьПравил.НеОстанавливатьПоОшибке = НеОстанавливатьПоОшибке;
	ЗаписьПравил.РежимОтладки = РежимОтладки;
	ЗаписьПравил.РежимОтладкиВыгрузки = РежимОтладкиВыгрузки;
	ЗаписьПравил.РежимОтладкиЗагрузки = РежимОтладкиЗагрузки;
	ЗаписьПравил.РежимПротоколированияОбменаДанными = РежимПротоколированияОбменаДанными;
	ЗаписиПравилКонвертации.Записать(Истина);
КонецПроцедуры

#КонецОбласти
