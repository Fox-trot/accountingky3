﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);

	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Не КомпоновщикИнициализирован Тогда
		ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	Если Не КомпоновщикИнициализирован И ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ИнициализацияКомпоновщикаНастроек();
	ИначеЕсли КомпоновщикИнициализирован Тогда
		ИзменениеСхемыКомпоновкиДанныхНаСервере();
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область Период

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Организация

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияИсходноеЗначение = ПолеОрганизация Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияИзменилась = Истина;
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Отчет.Организация);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область Счет

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	Если СчетИсходноеЗначение = Отчет.Счет Тогда
		Возврат;
	КонецЕсли;
	
	СчетПриИзмененииСервер();
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Результат

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область Показатели

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКоличествоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область Оформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЕдиницуИзмеренияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКолонтитулы(Команда)
	Перем Настройки;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("НастройкиКолонтитулов", Настройки);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаКолонтитулов",
		Новый Структура("Настройки", Настройки),
		ЭтотОбъект,
		УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("ЗапомнитьНастройкиКолонтитулов", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

// Обработчик закрытия общей формы НастройкаКолонтитулов.
//  См. Синтакс-помощник: ОткрытьФорму - ОписаниеОповещенияОЗакрытии.
//
&НаКлиенте
Процедура ЗапомнитьНастройкиКолонтитулов(Настройки, ДополнительныеПараметры) Экспорт 
	ПредыдущиеНастройки = Неопределено;
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("НастройкиКолонтитулов", ПредыдущиеНастройки);
	
	Если Настройки <> ПредыдущиеНастройки Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("НастройкиКолонтитулов", Настройки);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
		
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");		
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		СкрытьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)

	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;

	ОткрытьНастройки();

КонецПроцедуры

//&НаКлиенте
//Процедура ПоказатьКонтекстныеНовости(Команда)

//	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
//		ЭтаФорма,
//		Команда
//	);

//КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаВесьЭкран(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата());

	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтаФорма);
	ТекущийЭлемент = Элементы.Сформировать;
	
КонецПроцедуры

#Область ОбработчикиКомандРасчетаПоказателей

&НаКлиенте
Процедура РассчитатьСумму(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьКоличество(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСреднее(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМинимум(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМаксимум(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьВсеПоказатели(Команда)
	УстановитьВидимостьПоказателей(Не Элементы.РассчитатьВсеПоказатели.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура СвернутьПоказатели(Команда)
	УстановитьВидимостьПоказателей(Ложь);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Отчет.ПоказательБУ);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Отчет.ПоказательВалютнаяСумма);
	ПараметрыОтчета.Вставить("ПоказательКоличество"             , Отчет.ПоказательКоличество);
	ПараметрыОтчета.Вставить("Периодичность"                    , Отчет.Периодичность);
	ПараметрыОтчета.Вставить("Счет"                             , Отчет.Счет);
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Справочники.ВидыОтветственныхЛиц.ГлавныйБухгалтер);
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , ВыводитьЕдиницуИзмерения);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Карточка счета %1%2'"),
		Отчет.Счет,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	СписокПолей.Добавить("ПериодГруппировки");
	
	Для Индекс = 1 По 3 Цикл
		СписокПолей.Добавить("ВидСубконто" + Индекс);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Отчет.Счет) Тогда 
		КоличествоСубконто = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;
	Иначе
		КоличествоСубконто = 0;
	КонецЕсли;
	Для Индекс = КоличествоСубконто + 1 По 3 Цикл
		СписокПолей.Добавить("Субконто" + Индекс);
	КонецЦикла;
	
	Если Не Отчет.ПоказательВалютнаяСумма Тогда
		СписокПолей.Добавить("Валюта");
	КонецЕсли;
	
	Если Режим = "Отбор" Тогда
		Для Каждого ИмяПоказателя Из НаборПоказателей Цикл
			Если Не Отчет["Показатель" + ИмяПоказателя] Тогда
				СписокПолей.Добавить(ИмяПоказателя + "Дт");
				СписокПолей.Добавить(ИмяПоказателя + "Кт");
				Если ИмяПоказателя = "ВалютнаяСумма" Тогда
					СписокПолей.Добавить("Валюта");
					СписокПолей.Добавить("ВалютаДт");
					СписокПолей.Добавить("ВалютаКт");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура СчетПриИзмененииСервер()
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	Иначе
		
		Если Не Отчет.РежимРасшифровки Тогда
			
			БухгалтерскиеОтчеты.СохранитьОписаниеНастроек(ЭтотОбъект, СчетИсходноеЗначение);
			
		КонецЕсли;
		
		ИзменениеСхемыКомпоновкиДанныхНаСервере();
		
	КонецЕсли;
	
	БухгалтерскиеОтчеты.ПрочитатьОписаниеНастроек(ЭтотОбъект, Отчет.Счет);
	
	УправлениеФормой(ЭтаФорма);
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанныхНаСервере() Экспорт
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	
	Если ЗначениеЗаполнено(Отчет.Счет) Тогда
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
		
		КоличествоСубконто = СвойстваСчета.КоличествоСубконто;
		ИмяПоляПрефикс = "Субконто";
		
		// Изменение представления и наложения ограничения типа значения.
		Для Индекс = 1 По КоличествоСубконто Цикл
			Поле = Схема.НаборыДанных[0].Поля.Найти(ИмяПоляПрефикс + Индекс);
			Если Поле <> Неопределено Тогда
				Поле.Заголовок   = СвойстваСчета["ВидСубконто" + Индекс + "Наименование"];
				Поле.ТипЗначения = СвойстваСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			КонецЕсли;
		КонецЦикла;
		
		СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, СхемаКомпоновкиДанных);
		Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Перем ЗаполнятьКоллекцию;
	
	Если ЗаполняемыеНастройки.Свойство("Отбор", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда

		БухгалтерскиеОтчеты.ПреобразоватьОтборыПоСчету(Отчет.КомпоновщикНастроек.Настройки.Отбор,
			СчетИсходноеЗначение, Отчет.Счет);
			
		Если ЗаполняемыеНастройки.Количество() = 1 Тогда
			// Заполнение отборов может вызываться отдельно из процедуры БухгалтерскиеОтчеты.ПрочитатьОписаниеНастроек() .
			// В этом случае нет необходимости инициализировать лишние переменные (например, ДанныеСчета).
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
	Если ЗаполняемыеНастройки.Свойство("Показатели", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда
		// Управление показателями.
		Отчет.ПоказательБУ            = Истина;

		Отчет.ПоказательВалютнаяСумма = ДанныеСчета.Валютный;
		Отчет.ПоказательКоличество    = ДанныеСчета.Количественный;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсходныеЗначения(Форма)
	
	Отчет    = Форма.Отчет;
	
	Форма.СчетИсходноеЗначение        = Отчет.Счет;
	Форма.ОрганизацияИсходноеЗначение = Форма.ПолеОрганизация;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;

	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
	
	Элементы.ПоказательВалютнаяСумма.Доступность = ДанныеСчета.Валютный ИЛИ ДанныеСчета.ЗапретитьИспользоватьВПроводках;
	Элементы.ПоказательКоличество.Доступность    = ДанныеСчета.Количественный;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Результат = РезультатВыполнения.Результат;	

	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
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

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , Отчет.КонецПериода);
	СписокПараметров.Вставить("СчетУчета"         , Отчет.Счет);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	Перем ТекущаяКоманда;
	
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Если Элементы[Команда.Ключ].Пометка Тогда 
			ТекущаяКоманда = Команда.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	РассчитатьПоказатели(ТекущаяКоманда);
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияКомпоновщикаНастроек()
	
	БухгалтерскиеОтчетыВызовСервера.ИнициализацияКомпоновщикаНастроек(ЭтаФорма, ОрганизацияИзменилась);

	ИзменениеСхемыКомпоновкиДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Функция АдресХранилищаРезультата()
	
	Возврат ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
КонецФункции

#Область РасчетПоказателейВыделенныхЯчеек

// Выполняет расчет и вывод показателей выделенной области ячеек.
// См. обработчик события ОтчетТабличныйДокументПриАктивизацииОбласти.
//
&НаКлиенте
Процедура РассчитатьПоказателиДинамически()
	Перем ТекущаяКоманда;
	
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Если Элементы[Команда.Ключ].Пометка Тогда 
			ТекущаяКоманда = Команда.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	РассчитатьПоказатели(ТекущаяКоманда);
КонецПроцедуры

// Выполняет расчет и вывод показателей выделенных областей ячеек табличного документа.
//
// Параметры:
//  ТекущаяКоманда - Строка - имя команды расчета показателя, например, "РассчитатьСумму".
//                      Определяет, какой показатель является основным.
//
&НаКлиенте
Процедура РассчитатьПоказатели(ТекущаяКоманда = "РассчитатьСумму")
	// Расчет показателей.
	ПараметрыРасчета = БухгалтерскиеОтчетыКлиент.ПараметрыРасчетаПоказателейЯчеек(Результат);
	Если ПараметрыРасчета.РассчитатьНаСервере Тогда 
		РасчетныеПоказатели = РасчетныеПоказателиСервер(ПараметрыРасчета);
	Иначе
		РасчетныеПоказатели = ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(
			Результат, ПараметрыРасчета.ВыделенныеОбласти);
	КонецЕсли;
	
	// Установка значений показателей.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РасчетныеПоказатели);
	
	// Переключение и форматирование показателей.
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Элементы[Команда.Ключ].Пометка = Ложь;
		
		ЗначениеПоказателя = РасчетныеПоказатели[Команда.Значение];
		РазрядностьПоказателя = Мин(СтрДлина(Макс(ЗначениеПоказателя, -ЗначениеПоказателя) % 1) - 2, 4);
		
		Элементы[Команда.Значение].ФорматРедактирования = "ЧДЦ=" + РазрядностьПоказателя + "; ЧРГ=' '; ЧН=0";
	КонецЦикла;
	Элементы[ТекущаяКоманда].Пометка = Истина;
	
	// Вывод основного показателя.
	ТекущийПоказатель = КомандыПоказателей[ТекущаяКоманда];
	БыстрыйПоказатель = ЭтотОбъект[ТекущийПоказатель];
	Элементы.БыстрыйПоказатель.ФорматРедактирования = Элементы[ТекущийПоказатель].ФорматРедактирования;
	Элементы.ГруппаВидыПоказателей.Картинка = БиблиотекаКартинок[ТекущийПоказатель];
КонецПроцедуры

// Рассчитывает показатели числовых ячеек в табличном документе.
//  см. ОтчетыКлиентСервер.РасчетныеПоказателиЯчеек.
//
&НаСервере
Функция РасчетныеПоказателиСервер(ПараметрыРасчета)
	Возврат ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(Результат, ПараметрыРасчета.ВыделенныеОбласти);
КонецФункции

// Определяет соответствие между командами расчета показателей и показателями.
//
// Возвращаемое значение:
//   Соответствие - Ключ - имя команды, Значение - имя показателя.
//
&НаКлиенте
Функция КомандыПоказателей()
	КомандыПоказателей = Новый Соответствие();
	КомандыПоказателей.Вставить("РассчитатьСумму", "Сумма");
	КомандыПоказателей.Вставить("РассчитатьКоличество", "Количество");
	КомандыПоказателей.Вставить("РассчитатьСреднее", "Среднее");
	КомандыПоказателей.Вставить("РассчитатьМинимум", "Минимум");
	КомандыПоказателей.Вставить("РассчитатьМаксимум", "Максимум");
	
	Возврат КомандыПоказателей;
КонецФункции

// Управляет признаком видимости панели расчетных показателей.
//
// Параметры:
//  Видимость - Булево - Признак включения / выключения видимости панели показателей.
//              См. также Синтакс-помощник: ГруппаФормы.Видимость.
//
&НаКлиенте
Процедура УстановитьВидимостьПоказателей(Видимость)
	Элементы.ОбластьПоказателей.Видимость = Видимость;
	Элементы.РассчитатьВсеПоказатели.Пометка = Видимость;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
