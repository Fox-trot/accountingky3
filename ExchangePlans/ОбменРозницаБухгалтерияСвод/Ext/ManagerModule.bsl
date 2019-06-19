﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	
	Настройки.НазначениеПланаОбмена = "РИББезФильтра";
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных     = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет синхронизировать данные между конфигурацией Розница ред. 2 и Бухгалтерия Предприятия ред. 3. 
	|В синхронизации участвует следующий объект: Свод по рознице.
	|
	|Синхронизация является односторонней.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ОбменРозницаБухгалтерияСвод.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена распределенной информационной базы'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
	ОписаниеВарианта.ИмяФормыПомощникаНастройкиСинхронизацииДанных = "ПланОбмена.ОбменРозницаБухгалтерияСвод.Форма.ПомощникНастройкиСинхронизацииДанных";
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя.
// Прикладной разработчик на основе установленных отборов на узле должен сформировать 
// строку описания ограничений удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена.
//  ВерсияКорреспондента   - Строка    - версия корреспондента.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//
// Возвращаемое значение:
//  Строка - описание ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Описание = НСтр("ru = 'В распределенном узле информационной базы доступны все данные.'");
	
	Возврат Описание;
	
КонецФункции

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли