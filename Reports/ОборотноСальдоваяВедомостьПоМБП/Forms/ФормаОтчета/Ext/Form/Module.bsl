﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если НЕ ИнформационнаяБазаФайловая Тогда
		
		Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		Иначе
			ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии", БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(), Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
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
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервереВОтчетеРуководителю(ЭтотОбъект, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

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
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Отчет.Организация);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
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

/////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ РЕЗУЛЬТАТА

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

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

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


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБПКлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаВесьЭкран(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата());

	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтаФорма);
	ТекущийЭлемент = Элементы.СформироватьОтчет;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию(Команда)
	УстановитьНастройкиПоУмолчаниюНаСервере();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	МенеджерОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы);
	
	ПараметрыОтчета = МенеджерОтчета.ПустыеПараметрыКомпоновкиОтчета();
	
	ПараметрыОтчета.НачалоПериода                     = Отчет.НачалоПериода;
	ПараметрыОтчета.КонецПериода                      = Отчет.КонецПериода;
	ПараметрыОтчета.Организация                       = Отчет.Организация;
	ПараметрыОтчета.РазмещениеДополнительныхПолей     = Отчет.РазмещениеДополнительныхПолей;
	ПараметрыОтчета.Группировка                       = Отчет.Группировка.Выгрузить();
	ПараметрыОтчета.ДополнительныеПоля                = Отчет.ДополнительныеПоля.Выгрузить();
	
	ПараметрыОтчета.ВыводитьЗаголовок                 = ВыводитьЗаголовок;
	ПараметрыОтчета.ВыводитьПодвал                    = ВыводитьПодвал;
	ПараметрыОтчета.МакетОформления                   = МакетОформления;
	ПараметрыОтчета.РежимРасшифровки                  = Отчет.РежимРасшифровки;
	ПараметрыОтчета.ДанныеРасшифровки                 = ДанныеРасшифровки;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	ПараметрыОтчета.ИдентификаторОтчета               = БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Название = ?(ЗначениеЗаполнено(Форма.ПредставлениеТекущегоВарианта), Форма.ПредставлениеТекущегоВарианта, "Оборотно-сальдовая ведомость по МБП");
	ЗаголовокОтчета = Название + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	
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
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда		
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);

	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ИнформационнаяБазаФайловая Тогда
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
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
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

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_СформироватьПриОткрытии()
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФормированиеОтчета()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе
		СкрытьНастройки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	РассылкаОтчетовБП.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция АдресХранилищаРезультата()
	
	Возврат ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура УстановитьНастройкиПоУмолчаниюНаСервере()
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
КонецПроцедуры 

#КонецОбласти
