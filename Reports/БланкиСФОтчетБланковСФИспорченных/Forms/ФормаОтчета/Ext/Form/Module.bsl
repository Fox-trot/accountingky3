﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода  = КонецДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовШапки

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	ОчиститьСообщения();
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();	
	
	РезультатВыполнения = СформироватьОтчетНаСервере(ПараметрыОтчета);
	ПараметрыОбработчикаОжидания = Новый Структура();
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВычислитьСумму(Команда)
	СтандартныеПодсистемыКлиент.ПоказатьРасчетЯчеек(ЭтотОбъект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	ПоказатьДиалогОтправкиПоЭлектроннойПочте();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода, КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	ЗаголовокОтчета = НСтр("ru = 'Реестр испорченных бланков счет Фактур %1'");
	ЗаголовокОтчета = СтрШаблон(ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Форма.НачалоПериода, Форма.КонецПериода));

	Форма.Заголовок = ЗаголовокОтчета;
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере(ПараметрыОтчета)
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	АдресРасшифровки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("АдресРасшифровки", АдресРасшифровки);
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Отчеты.БланкиСФОтчетБланковСФИспорченных.Сформировать",
		ПараметрыОтчета,
		СтрШаблон(НСтр("ru = 'Выполнение отчета: %1'"), ЗаголовокОтчета));
	
	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

// Функция - Подготовить параметры отчета
// 
// Возвращаемое значение:
//  ПараметрыОтчета - Структура - набор параметров, необходимых для построения отчета.
//
&НаСервере
Функция ПодготовитьПараметрыОтчета() Экспорт
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода",	НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода",	КонецПериода);
	ПараметрыОтчета.Вставить("Организация", 	Организация);
	
	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	
	ИдентификаторЗадания = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	ТабличныеДокументы = Новый СписокЗначений;
	ТабличныеДокументы.Добавить(Результат, ЗаголовокОтчета);
	
	ЗаголовокСохранения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отправка отчета ""%1"" по почте'"), ЗаголовокОтчета);
	
	ПараметрыОтправки = Новый Структура("Тема", ЗаголовокОтчета);
	
	МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
	МодульРаботаСПочтовымиСообщениямиКлиент.ОтправитьТабличныеДокументы(ТабличныеДокументы, ЗаголовокСохранения, ПараметрыОтправки);
КонецПроцедуры

#КонецОбласти
